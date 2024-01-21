//==================================================================================================
//  Filename      : Basic_GeMM_CIM.v
//  Created On    : 2022-10-07 08:17:17
//  Last Modified : 2024-01-13 21:21:48
//  Revision      : Rongqing Cong
//  Author        : Bonan Yan
//  Company       : Peking University
//  Email         : bonanyan@pku.edu.cn
//
//  Description   : 
//
//
//==================================================================================================

`include "./defines.v"

module Basic_GeMM_CIM (
//output
      mem_read_data,
      cim_out,
//input
      clk,
      addr,
      cs,
      web,
      cimeb,
      mem_write_data,
      cim_in
);

//--------------Generated Parameters----------------------- 
parameter RAM_DEPTH = 1 << `ADDR_WIDTH;
parameter ADC_INPUT_PRECISION = `CIM_INPUT_PRECISION + `DATA_WIDTH;

//--------------Input Ports----------------------- 
input                  clk; //clk input
input [`ADDR_WIDTH-1:0] addr; //address, both effective in memory mode & CIM mode
input                  cs; //overall enable, chip select
input                  web; //write enable, low active
input                  cimeb; //CIM enable, low active
input [`DATA_WIDTH-1:0] mem_write_data; //memory mode input data
input [`CIM_INPUT_PRECISION*`CIM_INPUT_PARALLELISM-1:0] cim_in;

//--------------Output Ports----------------------- 
output [`DATA_WIDTH-1:0] mem_read_data; //memory mode output data
output [`ADC_PRECISION*`CIM_OUTPUT_PARALLELISM-1:0] cim_out;

//--------------Internal variables---------------- 

reg [`DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];
reg [ADC_INPUT_PRECISION-1:0] cim_out_reg [0:`CIM_OUTPUT_PARALLELISM];
reg [`DATA_WIDTH-1:0] mem_read_data_reg;
wire [`CIM_INPUT_PRECISION-1:0] cim_in_data[0:`CIM_INPUT_PARALLELISM];
wire [ADC_INPUT_PRECISION-1:0] cim_out_tmp [0:`CIM_OUTPUT_PARALLELISM];


//--------------Code Starts Here------------------ 

// unpack cim input
genvar i;
for (i=0; i < `CIM_INPUT_PARALLELISM;i=i+1) begin
    assign cim_in_data[i] = cim_in[(`CIM_INPUT_PARALLELISM-i)*`CIM_INPUT_PRECISION-1:(`CIM_INPUT_PARALLELISM-i-1)*`CIM_INPUT_PRECISION];
end

// pack up cim output
genvar j;
generate
  for (j=0;j < `CIM_OUTPUT_PARALLELISM;j=j+1) 
  begin
    assign cim_out_tmp[j] = cim_out_reg[j];
    assign cim_out[(`CIM_OUTPUT_PARALLELISM-j)*`ADC_PRECISION-1:(`CIM_OUTPUT_PARALLELISM-j-1)*`ADC_PRECISION] 
          = (cs && web && !cimeb) ? cim_out_tmp[j][ADC_INPUT_PRECISION-1:ADC_INPUT_PRECISION-`ADC_PRECISION] : 0;
  end
endgenerate

// memory read output
assign mem_read_data = (cs && web && cimeb) ? mem_read_data_reg : 0;


// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && !web && cimeb) begin
       mem[addr] <= mem_write_data;
   end
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1

integer out_num;
always @ (posedge clk)
begin : MEM_READ
  if (cs && web) begin
    if(cimeb) begin
      mem_read_data_reg <= mem[addr];
    end else begin
      // enter cim mode
      for (out_num=0;out_num < `CIM_OUTPUT_PARALLELISM;out_num=out_num+1) begin
        cim_out_reg[out_num] = cim_in_data[0] * mem[{4'd0,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[1] * mem[{4'd1,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[2] * mem[{4'd2,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[3] * mem[{4'd3,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[4] * mem[{4'd4,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[5] * mem[{4'd5,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[6] * mem[{4'd6,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[7] * mem[{4'd7,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[8] * mem[{4'd8,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[9] * mem[{4'd9,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[10] * mem[{4'd10,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[11] * mem[{4'd11,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[12] * mem[{4'd12,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[13] * mem[{4'd13,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[14] * mem[{4'd14,addr[9:7],out_num,addr[2:0]}]
                    + cim_in_data[15] * mem[{4'd15,addr[9:7],out_num,addr[2:0]}];
      end
    end
  end
end


endmodule // Basic_GeMM_CIM