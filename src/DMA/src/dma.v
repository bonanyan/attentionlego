module naive_DMA #
(
    parameter   CIM_DATA_WIDTH   = 8,
                BUS_DATA_WIDTH   = 32,
                CIM_ADDR_WIDTH   = 7,
                BUS_ADDR_WIDTH   = 32,
                DMODEL           = 4096,
                D_K              = 128,
                SEQ_LENGTH_BIT   = 11
)
(
    /* --------------------------------- global --------------------------------- */
    input                               clk,
    input                               rst,

    /* ----------------------------- top controller ----------------------------- */
    input  [BUS_ADDR_WIDTH-1:0]         weight_address,     // memory start address
    input  [31:0]                       sequence_length,    // sequence length
    input                               en_weight_dma,      // enable load qkv weight matrix
    input                               en_loadk_dma,       // enable transfer K matrix
    input                               en_loadq_dma,       // enable transfer Q matrix
    input                               en_loadscore_dma,   // enable transfer score matrix
    output                              done_weight_dma,    // finish load weight
    output                              done_loadq_dma,     // finish transfer Q
    output                              done_loadscore_dma, // finish transfer score


    /* --------------------------------- QKV cal -------------------------------- */
    output [CIM_DATA_WIDTH*DMODEL-1:0]  data_in_cim,        // cim write data
    output [CIM_ADDR_WIDTH-1:0]         addr_col_cim,       // cim write address
    output                              web_cim,            // cim write enable
    input                               web_done_cim,       // finish write one line
    input  [CIM_DATA_WIDTH*D_K-1:0]     data_out_cim,       // cim read data


    /* ------------------------------- QK compute ------------------------------- */
    input                               input_done_ld_k,    // finish load one K line
    output [CIM_DATA_WIDTH*D_K-1:0]     k_input,            // K matrix
    output [CIM_DATA_WIDTH*D_K-1:0]     q_input,            // Q matrix
    output [SEQ_LENGTH_BIT-1:0]         k_address,          // K matrix address

    input  [CIM_DATA_WIDTH*(1<<SEQ_LENGTH_BIT)-1:0] score_qk_output,    // score matrix
    output [CIM_DATA_WIDTH*(1<<SEQ_LENGTH_BIT)-1:0] cmIn_softmax,       // softmax input

    /* ------------------------------ memory (bus) ------------------------------ */
    input  [BUS_DATA_WIDTH-1:0]         mem_data_rd     ,   // read from mem
    output [BUS_DATA_WIDTH-1:0]         mem_data_wr     ,   // write to mem
    output [BUS_ADDR_WIDTH-1:0]         mem_addr        ,   // rd/wr address to mem
    output                              mem_wr_en           // mem write enable
);

    localparam  IDLE         = 0,
                MEM          = 1,
                LD_WEIGHT    = 2,
                LD_K         = 3,
                LD_Q         = 4,
                LD_SCORE     = 5,
                DONE         = 6;

    localparam MEM_DATA_NUM_LD = DMODEL * CIM_DATA_WIDTH / BUS_DATA_WIDTH;

    reg [2:0]                    state;
    reg [31:0]                   cnt_mem_data_num;
    reg                          mem_wr_en_reg;
    reg [BUS_DATA_WIDTH-1:0]     mem_data_wr_reg;
    reg [BUS_ADDR_WIDTH-1:0]     mem_addr_reg;
    reg [CIM_ADDR_WIDTH-1:0]     addr_col_cim_reg;
    reg [BUS_DATA_WIDTH-1:0]     mem_data_reg[0:MEM_DATA_NUM_LD-1];
    reg [CIM_DATA_WIDTH*D_K-1:0] k_input_reg;
    reg [CIM_DATA_WIDTH*D_K-1:0] q_input_reg;
    reg [SEQ_LENGTH_BIT-1:0]     k_address_reg;
    reg [CIM_DATA_WIDTH*(1<<SEQ_LENGTH_BIT)-1:0] cmIn_softmax_reg;

    assign mem_data_wr           = mem_data_wr_reg;
    assign mem_addr              = mem_addr_reg;
    assign mem_wr_en             = mem_wr_en_reg;
    assign addr_col_cim          = addr_col_cim_reg;
    assign k_address             = k_address_reg;
    assign k_input               = k_input_reg;
    assign q_input               = q_input_reg;
    assign web_cim               = en_weight_dma    ? ~(state == LD_WEIGHT) : 1'b1;
    assign done_weight_dma       = en_weight_dma    ?  (state == DONE)      : 1'b0;
    assign done_loadq_dma        = en_loadq_dma     ?  (state == DONE)      : 1'b0;
    assign done_loadscore_dma    = en_loadscore_dma ?  (state == DONE)      : 1'b0;

    genvar i;
    generate
        for (i = 0; i < MEM_DATA_NUM_LD; i = i + 1)
        begin
            assign data_in_cim[BUS_DATA_WIDTH*(i+1)-1:BUS_DATA_WIDTH*i] = mem_data_reg[MEM_DATA_NUM_LD-1-i];
        end
    endgenerate

    always @( posedge clk or negedge rst )
    begin
        if ( !rst )
        begin
            state <= IDLE;
        end

        else
        begin
            case ( state )
                IDLE:
                begin
                    if ( en_weight_dma )
                    begin
                        state            <= MEM;
                        cnt_mem_data_num <= 0;
                        mem_wr_en_reg    <= 1'b0;
                        mem_data_wr_reg  <= 0;
                        mem_addr_reg     <= weight_address;
                        addr_col_cim_reg <= 0;
                    end
                    else if ( en_loadk_dma )
                    begin
                        state            <= LD_K;
                        k_input_reg      <= data_out_cim;
                        k_address_reg    <= 0;
                    end
                    else if ( en_loadq_dma )
                    begin
                        state            <= LD_Q;
                        q_input_reg      <= data_out_cim;
                    end
                    else if ( en_loadscore_dma )
                    begin
                        state            <= LD_SCORE;
                        cmIn_softmax_reg <= score_qk_output;
                    end
                end
                MEM:
                begin
                    if ( cnt_mem_data_num == MEM_DATA_NUM_LD )
                    begin
                        state            <= LD_WEIGHT;
                        cnt_mem_data_num <= 0;
                    end
                    else
                    begin
                        mem_addr_reg                     <= mem_addr_reg + 4;
                        mem_data_reg[cnt_mem_data_num]   <= mem_data_rd;
                        cnt_mem_data_num                 <= cnt_mem_data_num + 1;
                    end
                end
                LD_WEIGHT:
                begin
                    if ( en_weight_dma )
                    begin
                        if ( addr_col_cim_reg == (1 << CIM_ADDR_WIDTH) - 1)
                            state            <= web_done_cim ? DONE : LD_WEIGHT;
                        else
                        begin
                            state            <= web_done_cim ? MEM : LD_WEIGHT;
                            addr_col_cim_reg <= web_done_cim ? (addr_col_cim_reg + 1) : addr_col_cim_reg;
                        end
                    end
                end
                LD_K:
                begin
                    if ( k_address_reg == (1 << SEQ_LENGTH_BIT) - 1 )
                        state            <= input_done_ld_k ? DONE : LD_K;
                    else
                    begin
                        k_address_reg    <= input_done_ld_k ? (k_address_reg + 1) : k_address_reg;
                        k_input_reg      <= input_done_ld_k ? data_out_cim : k_input_reg;
                    end
                end
                LD_Q:
                    state <= DONE;
                LD_SCORE:
                    state <= DONE;
                DONE:
                    state <= IDLE;
                default:
                    state <= IDLE;
            endcase
        end
    end


endmodule