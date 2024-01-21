`include "src/dma.v"

module dma_tb;

    reg         clk,
                rst,
                en_weight_dma,
                en_loadk_dma,
                en_loadq_dma,
                en_loadscore_dma,
                web_done_cim,
                input_done_ld_k;
    reg [7:0]   mem_data_rd;
    reg [31:0]  data_out_cim;
    reg [31:0]  weight_address;
    reg [31:0]  score_qk_output;

    wire        done_weight_dma;
    wire        done_loadq_dma;
    wire        web_cim;
    wire        mem_wr_en;
    wire [1:0]  addr_col_cim;
    wire [1:0]  k_address;
    wire [7:0]  mem_data_wr;
    wire [31:0] data_in_cim;
    wire [31:0] mem_addr;
    wire [31:0] k_input;
    wire [31:0] q_input;
    wire [31:0] cmIn_softmax;

    always #5 clk = ~clk;

    initial
    begin
        $dumpfile("build/dma_tb.vcd");
        $dumpvars(0, dma_tb);

            clk = 1;
            rst = 0;
        #10 rst = 1;

        /* --------------------------------------------------------------------------
        TEST: load data from mem

        input data from mem:
        8'h12, 8'h34, 8'h56, 8'h78, 8'h9a, 8'hbc, 8'hde, 8'hf0
        8'h0f, 8'hde, 8'hcb, 8'ha9, 8'h87, 8'h65, 8'h43, 8'h21

        output data to CIM:
        32'h1234_5678, 32'h9abc_def0, 32'h0fde_cba9, 32'h8765_4321
           ------------------------------------------------------------------------- */

        #10
        en_weight_dma  = 1;
        weight_address = 0;


        #10 mem_data_rd = 8'h12;
        #10 mem_data_rd = 8'h34;
        #10 mem_data_rd = 8'h56;
        #10 mem_data_rd = 8'h78;    #20 web_done_cim = 1;
        #10 mem_data_rd = 8'h9a;        web_done_cim = 0;
        #10 mem_data_rd = 8'hbc;
        #10 mem_data_rd = 8'hde;
        #10 mem_data_rd = 8'hf0;    #20 web_done_cim = 1;
        #10 mem_data_rd = 8'h0f;        web_done_cim = 0;
        #10 mem_data_rd = 8'hde;
        #10 mem_data_rd = 8'hcb;
        #10 mem_data_rd = 8'ha9;    #20 web_done_cim = 1;
        #10 mem_data_rd = 8'h87;        web_done_cim = 0;
        #10 mem_data_rd = 8'h65;
        #10 mem_data_rd = 8'h43;
        #10 mem_data_rd = 8'h21;    #20 web_done_cim = 1;
        #10 web_done_cim = 0;
        en_weight_dma    = 0;

        /* --------------------------------------------------------------------------
        TEST: load K to QK_compute

        input data:
        32'h1234_5678, 32'h9abc_def0, 32'h0fde_cba9, 32'h8765_4321

        output data:
        32'h1234_5678, 32'h9abc_def0, 32'h0fde_cba9, 32'h8765_4321
           ------------------------------------------------------------------------- */

        #10
        en_loadk_dma     = 1;
        input_done_ld_k  = 0;
        data_out_cim     = 32'h1234_5678;

        #20 input_done_ld_k = 1;    data_out_cim = 32'h9abc_def0;
        #10 input_done_ld_k = 0;
        #20 input_done_ld_k = 1;    data_out_cim = 32'h0fde_cba9;
        #10 input_done_ld_k = 0;
        #20 input_done_ld_k = 1;    data_out_cim = 32'h8765_4321;
        #10 input_done_ld_k = 0;
        #20 input_done_ld_k = 1;
        en_loadk_dma = 0;

        /* --------------------------------------------------------------------------
        TEST: load Q to QK_compute

        input data:
        32'h1234_5678

        output data:
        32'h1234_5678
           ------------------------------------------------------------------------- */

        #10
        en_loadq_dma = 1;
        data_out_cim = 32'h1234_5678;

        #30
        en_loadq_dma = 0;

        /* --------------------------------------------------------------------------
        TEST: load Score to Softmax Unit

        input data:
        32'h1234_5678

        output data:
        32'h1234_5678
           ------------------------------------------------------------------------- */

        #10
        en_loadscore_dma = 1;
        score_qk_output  = 32'h1234_5678;

        #30
        en_loadscore_dma = 0;

        #50 $finish;
    end

    naive_DMA
    #(
        .CIM_DATA_WIDTH  (8),
        .BUS_DATA_WIDTH  (8),
        .CIM_ADDR_WIDTH  (2),
        .BUS_ADDR_WIDTH  (32),
        .DMODEL          (4),
        .D_K             (4),
        .SEQ_LENGTH_BIT  (2)
    ) dut
    (
        .clk                 (clk),
        .rst                 (rst),

        .en_weight_dma       (en_weight_dma),
        .weight_address      (weight_address),
        .done_weight_dma     (done_weight_dma),

        .en_loadk_dma        (en_loadk_dma),

        .en_loadq_dma        (en_loadq_dma),
        .done_loadq_dma      (done_loadq_dma),

        .en_loadscore_dma    (en_loadscore_dma),
        .done_loadscore_dma  (done_loadscore_dma),

        .data_in_cim         (data_in_cim),
        .addr_col_cim        (addr_col_cim),
        .web_done_cim        (web_done_cim),

        .data_out_cim        (data_out_cim),
        .input_done_ld_k     (input_done_ld_k),
        .k_input             (k_input),
        .q_input             (q_input),
        .k_address           (k_address),

        .score_qk_output     (score_qk_output),
        .cmIn_softmax        (cmIn_softmax),

        .mem_data_rd         (mem_data_rd),
        .mem_data_wr         (mem_data_wr),
        .mem_addr            (mem_addr),
        .mem_wr_en           (mem_wr_en)
    );
endmodule