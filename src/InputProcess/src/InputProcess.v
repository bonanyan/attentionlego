//==================================================================================================
//  Filename      : WeightGenerator.v
//  Created On    : 2023-11-27 08:17:17
//  Last Modified : 2024-01-13 21:21:31
//  Revision      : 
//  Author        : Rongqing Cong
//  Company       : Peking University
//  Email         : congrongqing@pku.edu.cn
//
//  Description   : 
//  1. MEM WRITE  : write in an entire column for all pim modules
//  2. MEM READ   : read out an entire column for all pim modules
//  3. CIM MODE   : 
//
//==================================================================================================

`include "./apim.v"
`include "./defines.v"

module InputProcess (
    clk,
    rst,
    cs,
    web,
    cimeb,
    weight_sel,
    col_sel,
    data_in,
    data_out,
    mem_data_out,
    done
);

//----------------------------------
// choose different mode based on (web,cimeb):
// READ: (1,1), WRITE:(0,1), IDLE: (0,0), CIM:(1,0)
//----------------------------------

//--------------Input Ports----------------------- 
input                   clk;                // clk input
input                   rst;                // rst input
input                   cs;                 // overall enable, chip select
input                   web;                // write mem enable, low active
input                   cimeb;              // CIM enable, low active
input [2:0]             weight_sel;         // weight select, q(00), k(01), v(10)
input [`ADDR_COL_WIDTH-1:0]  col_sel;       // for write mode, column select
input [`DATA_WIDTH*`D_MODEL-1:0] data_in;    // memory or CIM mode input data

//--------------Output Ports----------------------- 
output [`DATA_WIDTH*`D_k-1:0] data_out;    // CIM mode output data
output [`DATA_WIDTH*`D_MODEL-1:0] mem_data_out; // memory mode output data
output reg done; 

//--------------Internal variables---------------- 

// ports link to cim module
reg [`CIM_INPUT_PRECISION*`CIM_INPUT_PARALLELISM-1:0] cim_data_in [0:`CIM_NUM];
wire [`ADC_PRECISION*`CIM_OUTPUT_PARALLELISM-1:0] cim_data_out [0:`CIM_NUM];
reg  [`DATA_WIDTH-1:0] mem_write_data [0:`CIM_NUM_ROW];
wire  [`DATA_WIDTH-1:0] mem_read_data [0:`CIM_NUM_ROW];
// tmp variables
wire [`DATA_WIDTH-1:0] data_in_unpack [0:`CIM_NUM_ROW][0:`CIM_ROW_WIDTH]; // A 2D array to hold the static connections
wire [`CIM_INPUT_PRECISION*`CIM_INPUT_PARALLELISM-1:0] cim_data_in_tmp [0:`CIM_NUM][0:`CIM_INPUT_SHARE];
reg [`DATA_WIDTH-1:0] mem_data_out_unpack [0:`CIM_NUM_ROW][0:`CIM_ROW_WIDTH];
reg [`DATA_WIDTH-1:0] cim_out_sum [0:`D_k];
wire [`DATA_WIDTH-1:0] cim_data_out_unpack [0:`CIM_OUTPUT_PARALLELISM];

wire [`ADDR_WIDTH-1:0] cim_addr;
reg [`ADDR_ROW_WIDTH-1:0] addr_row;    // state, CIM_INPUT_SHARE=8, 8 state in total
reg [`ADDR_COL_WIDTH-1:0] addr_col;
reg write_start, read_start;

wire web_cim, cimeb_cim;

//--------------Code Starts Here------------------ 

assign cim_addr = {addr_row, addr_col};
assign web_cim = (state_load == BUSY || state_cim == BUSY) ? web : 0;
assign cimeb_cim = (state_load == BUSY || state_cim == BUSY) ? cimeb : 0;

//--------------MEM WRITE & READ------------------ 
// Preload: dividing input and output into cim modules and rows, save as a 2D array
genvar i, j;
generate
    for (i = 0; i < `CIM_NUM_ROW; i = i + 1) begin
        for (j = 0; j < `CIM_ROW_WIDTH; j = j + 1) begin
            assign data_in_unpack[i][j] = data_in[(`CIM_ROW_WIDTH*i+j+1)*`DATA_WIDTH-1:(`CIM_ROW_WIDTH*i+j)*`DATA_WIDTH];
            assign mem_data_out[(`CIM_ROW_WIDTH*i+j+1)*`DATA_WIDTH-1:(`CIM_ROW_WIDTH*i+j)*`DATA_WIDTH] = mem_data_out_unpack[i][j];
        end
    end
endgenerate
// pack up result for cim
generate
    for (i = 0; i < `D_k; i = i + 1) begin
        assign data_out[(i+1)*`DATA_WIDTH-1:i*`DATA_WIDTH] = cim_out_sum[i];
    end
endgenerate
// Preload: dividing input into cim input share and parallel, save as a 3D array
genvar k;
generate
    for (i = 0; i < `CIM_NUM_ROW; i = i + 1) begin
        for (j = 0;j < `CIM_INPUT_SHARE;j = j + 1) begin
            for (k = 0;k < `CIM_INPUT_PARALLELISM;k = k + 1) begin
                assign cim_data_in_tmp[i][j][(k+1)*`CIM_INPUT_PRECISION-1:k*`CIM_INPUT_PRECISION] = data_in[(`CIM_ROW_WIDTH*i+j*`CIM_INPUT_SHARE+k+1)*`DATA_WIDTH-1:(`CIM_ROW_WIDTH*i+j*`CIM_INPUT_SHARE+k+1)*`DATA_WIDTH-`CIM_INPUT_PRECISION];
            end
        end
    end
endgenerate

// State definitions
localparam IDLE = 2'b00, BUSY = 2'b01, DONE = 2'b11;
reg [1:0] state_load;
reg [2:0] cycle_reg_load;  // 3-bit counter, enough to count up to 8

// read and write state update
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state_load <= IDLE;
        cycle_reg_load <= 0;
        addr_row <= 0;
    end
    else begin
        case (state_load)
        IDLE: begin
            done <= 0; // TODO 
            cycle_reg_load <= 0;
            state_load <= ((cs && web && cimeb) || (cs && !web && cimeb)) ? BUSY : IDLE;
            addr_row <= 0;
            addr_col <= col_sel;
        end
        BUSY: begin
            if (cycle_reg_load < `CIM_NUM_ROW) begin
                cycle_reg_load <= cycle_reg_load + 1;
                addr_row <= addr_row + 1;
            end 
            else begin
                cycle_reg_load <= 0;
                addr_row <= 0;
                state_load <= DONE;
            end
        end
        DONE: begin
            done <= 1;
            state_load <= IDLE;
            addr_row <= 0;
            addr_col <= 0;
        end
        default: state_load = IDLE;
    endcase
    end
end

// prepare the input for each pim module
integer m, n;
always @(*) begin
    for (m = 0;m<`CIM_NUM;m=m+1) begin
        mem_write_data[m] = data_in_unpack[m][addr_row];
        mem_data_out_unpack[m][addr_row] = mem_read_data[m];
    end
end

//--------------CIM MODE------------------ 
localparam SMALL_CYCLE = 2'b01, BIG_CYCLE = 2'b10;
reg [1:0] state_cim;

reg [2:0] small_cycle_reg; // 3 bits, counts 0 to 7
reg [7:0] big_cycle_reg;   // 8 bits, counts 0 to 127


// Next state logic and counter updates
always @(posedge clk or posedge rst) begin
    if (rst) begin
        state_cim <= IDLE;
        small_cycle_reg <= 0;
        big_cycle_reg <= 0;
        addr_row <= 0;
    end
    else begin
        case (state_cim)
        IDLE: begin
            done <= 0; // TODO 
            small_cycle_reg <= 0;
            big_cycle_reg <= 0;
            state_cim <= (cs && web && !cimeb) ? BUSY : IDLE;
            addr_row <= 0;
            addr_col <= 0;
            for (m=0;m<`D_k;m=m+1) begin
                cim_out_sum[m] <= 0;
            end
        end
        BUSY: begin
            if (big_cycle_reg < `CIM_OUTPUT_SHARE) begin
                if (small_cycle_reg < `CIM_INPUT_SHARE-1) begin
                    small_cycle_reg <= small_cycle_reg + 1;
                    addr_row <= addr_row + 1;
                end else begin
                    small_cycle_reg <= 0;
                    addr_row <= 0;
                    addr_col <= addr_col + 1;
                    big_cycle_reg <= big_cycle_reg + 1;
                end
                for(m=0;m<`CIM_OUTPUT_PARALLELISM;m=m+1) begin
                    cim_out_sum[m*`CIM_OUTPUT_SHARE+addr_col] <= cim_out_sum[m*`CIM_OUTPUT_SHARE+addr_col] + cim_data_out_unpack[m];
                end
            end 
            else begin
                small_cycle_reg <= 0;
                big_cycle_reg <= 0;
                state_cim <= DONE;
                // TODO: ctrl signal
            end
        end
        DONE: begin
            done <= 1;
            state_cim <= IDLE;
        end
        default: state_cim = IDLE;
    endcase
    end
end


// prepare the input for each pim module
always @(*) begin
    for (m = 0;m<`CIM_NUM;m=m+1) begin
        cim_data_in[m] = cim_data_in_tmp[m][addr_row];
    end
end

// unpack and sum up the result from cim module
for (j=0; j<`CIM_OUTPUT_PARALLELISM;j=j+1) begin
    assign cim_data_out_unpack[j] = cim_data_out[0][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[1][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[2][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[3][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[4][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[5][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[6][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[7][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[8][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[9][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[10][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[11][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[12][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[13][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[14][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[15][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[16][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[17][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[18][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[19][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[20][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[21][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[22][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[23][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[24][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[25][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[26][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[27][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[28][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[29][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[30][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION]
                            + cim_data_out[31][(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION];
end

//--------------Generate Instance------------------ 
genvar num;
generate
    // q,k,v, 3 modules in total
    for (num=0; num<3; num=num+1)
    begin
        for (i=0; i < `CIM_NUM; i=i+1)
        begin
            Basic_GeMM_CIM apim_q (
                .clk(clk),
                .cs(cs),
                .web(web_cim),
                .cimeb(cimeb_cim),
                .addr(cim_addr),
                .mem_write_data(mem_write_data[i]),
                .cim_in(cim_data_in[i]),
                .mem_read_data(mem_read_data[i]), // TODO
                .cim_out(cim_data_out[i])
            );
        end
    end
endgenerate

endmodule