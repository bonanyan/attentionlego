`include "constant.v"

module top_controller(
    input clk,rst,done_cimeb_qkv,done_k_mode_dma,done_q_mode_qk,done_cme_softmax,done_weight_dma,done_loadq_dma,down_loadscore_dma,
    output reg enable_cs_qkv,enable_cimeb_qkv,enable_cs_qk,enable_k_mode_qk,enable_q_mode_qk,enable_en_softmax,enable_cme_softmax,enable_weight_dma,enable_loadk_dma,enable_loadq_dma,enable_loadscore_dma,
    output reg [31:0] sequence_length,
    output reg [1:0] weight_sel_qkv,
    output reg [31:0] weight_address
);
    reg [3:0] i;
    reg [3:0] epoch;
    // reg [31:0] epoch_num;
    reg [3:0] state;
    reg [2:0] init_state;
    reg [2:0] init_init_state;
    // reg [2:0] init_weight;

    parameter STAT_IDLE = 5,
              STAT_INIT_INITIAL1 = 0,
              STAT_INIT_INITIAL2 = 1,
              STAT_INIT_INITIAL3 = 2,
              STAT_INITIAL1 = 0,
              STAT_INITIAL2 = 1,
              STAT_INITIAL3 = 2,
              STAT_INITIAL4 = 3,
              STAT_R0 = 0,
              STAT_R1 = 1,
              STAT_R2 = 2,
              STAT_R3 = 3,
              STAT_R4 = 4,
              qweight_address=8,
              kweight_address=9,
              vweight_address=10,
              input_address=11,
              BUS_ADDR_WIDTH = 32,
              sequence_length_init=2048;
              


    always @(state,init_state,init_init_state) begin
        if (state==0) begin
            if (init_state==0) begin
                enable_cs_qkv<=1;
                if (init_init_state==0) begin
                    weight_address<=qweight_address;
                    weight_sel_qkv<=0;
                    enable_weight_dma=1;
                end
                if (init_init_state==1) begin
                    weight_address<=kweight_address;
                    weight_sel_qkv<=1;
                    enable_weight_dma=1;
                end
                if (init_init_state==2) begin
                    weight_address<=vweight_address;
                    weight_sel_qkv<=2;
                    enable_weight_dma=1;
                end
            end
            else
                if (init_state==1) begin
                    enable_cs_qkv<=1;
                    weight_address<=input_address;
                    enable_weight_dma <=1;
                end
                else
                    if (init_state==2) begin
                        enable_cs_qkv<=1;
                        weight_sel_qkv<=1;
                        enable_cimeb_qkv <=1;
                    end
                    else begin
                        enable_cs_qkv<=1;
                        weight_sel_qkv<=0;
                        enable_cimeb_qkv <=1;
                        enable_cs_qk<=1;
                        enable_k_mode_qk<=1;
                        enable_loadk_dma<=1;
                    end

        end
        else begin
            if (state==1) begin
                enable_cs_qk<=1;
                enable_q_mode_qk<=1;
                enable_loadq_dma<=1;
                sequence_length<=sequence_length+1;
            end
            else 
                if (state==2) begin
                    enable_cs_qk<=1;
                    enable_q_mode_qk<=1;
                    enable_cs_qkv<=1;
                    weight_sel_qkv<=0;
                    enable_cimeb_qkv <=1;
                    if (epoch!=0) begin
                        enable_en_softmax<=1;
                        enable_cme_softmax<=1;
                    end

                end
                else
                    if (state==3) begin
                        enable_en_softmax<=1;
                        enable_loadscore_dma<=1;
                    end
                    else begin 
                            sequence_length<=0;
                            enable_cs_qkv<=0;
                            enable_cimeb_qkv<=0;
                            enable_cs_qk<=0;
                            enable_k_mode_qk<=0;
                            enable_q_mode_qk<=0;
                            enable_en_softmax<=0;
                            enable_cme_softmax<=0;
                            enable_weight_dma<=0;
                            enable_loadk_dma<=0;
                            enable_loadq_dma<=0;
                            enable_loadscore_dma<=0;
                            i<=0;
                            epoch<=0;
                            weight_sel_qkv<=1;
                            weight_address<=0;
                    end
        end
    end

    always @(posedge clk) begin
        if (rst==1) begin
            state <= STAT_IDLE;
            init_state<=0;
            init_init_state<=0;
        end
        else 
            case (state)
                STAT_R0: begin
                    case (init_state)
                        STAT_INITIAL1: begin
                            case (init_init_state)
                                STAT_INIT_INITIAL1: begin
                                    if (done_weight_dma==1) begin
                                        // enable_weight_dma <=0;
                                        init_init_state<=STAT_INIT_INITIAL2;
                                    end
                                end
                                STAT_INIT_INITIAL2: begin
                                    if (done_weight_dma==1) begin
                                        // enable_weight_dma <=0;
                                        init_init_state<=STAT_INIT_INITIAL3;
                                    end
                                end
                                STAT_INIT_INITIAL3: begin
                                    if (done_weight_dma==1) begin
                                        // enable_weight_dma <=0;
                                        init_state<=STAT_INITIAL2;
                                    end
                                end
                            endcase
                        end
                        STAT_INITIAL2: begin
                            if (done_weight_dma==1) begin
                                enable_weight_dma <=0;
                                init_state<=STAT_INITIAL3;
                            end
                        end
                        STAT_INITIAL3: begin
                            if (done_cimeb_qkv==1) begin
                                enable_cs_qkv<=0;
                                // weight_sel_qkv<=0;
                                enable_cimeb_qkv <=0;
                                init_state<=STAT_INITIAL4;
                            end
                        end
                        STAT_INITIAL4: begin
                            if (done_cimeb_qkv==1) begin
                                enable_cs_qkv<=0;
                                enable_cimeb_qkv <=0;
                                i<=i+1;
                            end
                            if (done_k_mode_dma==1) begin
                                enable_cs_qk<=0;
                                enable_k_mode_qk<=0;
                                enable_loadk_dma<=0;
                                i<=i+1;
                            end
                            if (i==2) begin
                                i<=0;
                                state<=STAT_R1;
                            end
                        end
                    endcase
                end
                STAT_R1: begin
                    if (done_loadq_dma==1) begin
                        enable_loadq_dma<=0;
                        state<=STAT_R2;
                    end
                end
                STAT_R2: begin
                    if (done_cimeb_qkv==1) begin
                        enable_cs_qkv<=0;
                        enable_cimeb_qkv <=0;
                        i<=i+1;
                    end
                    if (done_q_mode_qk==1) begin
                        enable_cs_qk<=0;
                        enable_q_mode_qk<=0;
                        i<=i+1;
                    end
                    if (done_cme_softmax==1 || epoch==0) begin
                        enable_en_softmax<=0;
                        enable_cme_softmax<=0;
                        i<=i+1;
                        epoch<=epoch+1;
                    end
                    if (i==3) begin
                        i<=0;
                        state<=STAT_R3;
                    end 
                end
                STAT_R3: begin
                    if (down_loadscore_dma==1) begin
                        enable_en_softmax<=0;
                        enable_loadscore_dma<=0;
                        state<=STAT_R1;
                        epoch<=epoch+1;
                    end
                end
                STAT_IDLE: begin
                    state<=0;
                    init_state<=0;
                    init_init_state<=0;
                end
            endcase
    end
endmodule
