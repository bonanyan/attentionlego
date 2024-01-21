`timescale 100ms/100ms
module top_controller_tb; 
reg clk, rst,done_cimeb_qkv,done_k_mode_dma,done_q_mode_qk,done_cme_softmax,done_weight_dma,done_loadk_dma,done_loadq_dma,down_loadscore_dma; 
reg [7:0] invect;
wire enable_cs_qkv,enable_cimeb_qkv,enable_cs_qk,enable_k_mode_qk,enable_q_mode_qk,enable_en_softmax,enable_cme_softmax,enable_weight_dma,enable_loadk_dma,enable_loadq_dma,enable_loadscore_dma; 
top_controller c1(.clk(clk),.rst(rst),.done_cimeb_qkv(done_cimeb_qkv),.done_k_mode_dma(done_k_mode_dma),.done_q_mode_qk(done_q_mode_qk),.done_cme_softmax(done_cme_softmax),.done_weight_dma(done_weight_dma),.done_loadq_dma(done_loadq_dma),.down_loadscore_dma(down_loadscore_dma),.enable_cs_qkv(enable_cs_qkv),.enable_cimeb_qkv(enable_cimeb_qkv),.enable_cs_qk(enable_cs_qk),.enable_k_mode_qk(enable_k_mode_qk),.enable_q_mode_qk(enable_q_mode_qk),.enable_en_softmax(enable_en_softmax),.enable_cme_softmax(enable_cme_softmax),.enable_weight_dma(enable_weight_dma),.enable_loadk_dma(enable_loadk_dma),.enable_loadq_dma(enable_loadq_dma),.enable_loadscore_dma(enable_loadscore_dma));
    initial begin
        clk = 1;
        forever #25 clk = ~clk;
    end

    // initial begin
    //     sa = 0;
    //     forever #100 sa = ~sa;
    // end

    // initial begin
    //     for (invect = 0; invect < 255; invect = invect + 1)
    //         begin
    //             #20 $display ("data_in = %b", data_in);
    //             data_in = invect[7:0];
    //         end
    // end

    initial begin
        rst = 1;
        invect=0;
        done_cimeb_qkv=0;
        done_k_mode_dma=0;
        done_q_mode_qk=0;
        done_cme_softmax=0;
        done_weight_dma=0;
        done_loadk_dma=0;
        done_loadq_dma=0;
        down_loadscore_dma=0;
        #200 rst = 0;
        #200
        #45 done_weight_dma=1;
        #50 done_weight_dma=0;
        #50 done_weight_dma=1;
        #50 done_weight_dma=0;
        #50 done_weight_dma=1;
        #50 done_weight_dma=0;
        #50 done_weight_dma=1;
        #50 done_weight_dma=0;
        #100 done_cimeb_qkv=1;
        #50 done_cimeb_qkv=0;
        #50 done_k_mode_dma=1;
        #50 done_k_mode_dma=0;
        done_cimeb_qkv=1;
        #50 done_cimeb_qkv=0;

        #50 done_loadq_dma=1;
        #50 done_loadq_dma=0;
        #100
        #50 done_q_mode_qk=1;
        #50 done_q_mode_qk=0;
        #50 done_cimeb_qkv=1;
        #50 done_cimeb_qkv=0;
        #50 down_loadscore_dma=1;
        #50 down_loadscore_dma=0;
        for (invect = 0; invect < 20; invect = invect + 1)
            begin
                #50 done_loadq_dma=1;
                #50 done_loadq_dma=0;
                #50 done_cme_softmax=1;
                #50 done_cme_softmax=0;
                #50 done_q_mode_qk=1;
                #50 done_q_mode_qk=0;
                #50 done_cimeb_qkv=1;
                #50 done_cimeb_qkv=0;
                #50 down_loadscore_dma=1;
                #50 down_loadscore_dma=0;
            end
        #200 rst = 1;
        #200 $finish;
    end

    initial
    begin            
        $dumpfile("top_controller_tb.vcd");  //生成vcd文件，记录仿真信息
        $dumpvars(0, top_controller_tb);  //指定层次数，记录信号
    end 
endmodule
