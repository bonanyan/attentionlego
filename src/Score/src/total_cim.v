`include "col_cim.v"

module QK_compute(
//output
    input_done,//1 bit
    output_done,//1 bit
    QK_output,//2048 * 8 bit
//input
    clk,//1 bit
    cs,//1 bit
    reset,//1 bit
    K_mode_enable,
    Q_mode_enable,
    K_address,//11 bit
    K_input,//128 * 8 bit
    Q_input,//128 * 8 bit
);
//--------------Input Ports----------------------- 
input    cs;
input    clk;
input    reset;
input    K_mode_enable;//高电平进入K_mode: 将K_input的输入（D_k维向量）存入CIM模块的第K_address列（K_address取值为0到sequence_length-1）
input    Q_mode_enable;//高电平进入Q_mode: 输入Q_input向量（D_k维），与CIM模块进行运算，得到一个sequence_length维的向量并置colomn_done为高电平
input    [ADDR_WIDTH - 1 : 0]      K_address;//K_mode下，用于指定是第几个输入的K向量（即存放在CIM中的第几列）
input    [BIT_WIDTH * D_k - 1 : 0]  K_input;
input    [BIT_WIDTH * D_k - 1 : 0]  Q_input;
//--------------Output Ports---------------------- 
output reg [BIT_WIDTH * MAX_SEQUENCE_LENGTH - 1 : 0]    QK_output;//对于一个输入的Q向量，输出QK转置的一行，可用于后续的softmax
output reg     output_done;//MAX_SEQUENCE_LENGTH长度的向量已被计算完毕，可以输出
output reg     input_done;//D_k长度的K_input已经被存储完毕
//-------------Internal variables----------------- 
parameter S0 = 0, S1 = 1, S2 = 2;
parameter ADDR_WIDTH = 11;
parameter BIT_WIDTH = 8;
parameter D_k = 128;
parameter MAX_SEQUENCE_LENGTH = 2048;

reg cimeb, web;
reg [1:0]   state;//0:idle 1:Kmode 2:Qmode
reg [10:0]  idx;//output index
reg [2:0]   ostep;//output step
reg [4:0]   istep;//input step
reg [5:0]   chip;//chip select
reg [63:0]  chip_one_hot;
reg [2:0]   out_select;
reg count;
reg ostep_wait;

reg [9:0]   a; //address, both effective in K mode & Q mode
reg [7:0]   d0[63:0], d1[63:0], d2[63:0], d3[63:0]; //memory mode input data
reg [7:0]  cim_in0[63:0], cim_in1[63:0], cim_in2[63:0], cim_in3[63:0],
            cim_in4[63:0], cim_in5[63:0], cim_in6[63:0], cim_in7[63:0],
            cim_in8[63:0], cim_in9[63:0], cim_in10[63:0], cim_in11[63:0],
            cim_in12[63:0], cim_in13[63:0], cim_in14[63:0], cim_in15[63:0];


wire [7:0] q0[63:0], q1[63:0], q2[63:0], q3[63:0]; //memory mode output data
wire [7:0] cim_out0[63:0], cim_out1[63:0], cim_out2[63:0], cim_out3[63:0],
          cim_out4[63:0], cim_out5[63:0], cim_out6[63:0], cim_out7[63:0];
reg [7:0] sum_total, temp_sum_total;
reg [7:0] cim_out;
//--------------Code Starts Here------------------ 
genvar i;
generate
  for (i = 0; i < 64; i = i + 1) begin
    col_cim cim(
      .q0(q0[i]), .q1(q1[i]), .q2(q2[i]), .q3(q3[i]),
      .cim_out0(cim_out0[i]), .cim_out1(cim_out1[i]),
      .cim_out2(cim_out2[i]), .cim_out3(cim_out3[i]),
      .cim_out4(cim_out4[i]), .cim_out5(cim_out5[i]),
      .cim_out6(cim_out6[i]), .cim_out7(cim_out7[i]),
      .clk(clk), .a(a), .cs(1'b1), .web(web), .cimeb(cimeb),
      .d0(d0[i]), .d1(d1[i]), .d2(d2[i]), .d3(d3[i]),
      .cim_in0(cim_in0[i]), .cim_in1(cim_in1[i]), .cim_in2(cim_in2[i]), .cim_in3(cim_in3[i]),
      .cim_in4(cim_in4[i]), .cim_in5(cim_in5[i]), .cim_in6(cim_in6[i]), .cim_in7(cim_in7[i]),
      .cim_in8(cim_in8[i]), .cim_in9(cim_in9[i]), .cim_in10(cim_in10[i]), .cim_in11(cim_in11[i]),
      .cim_in12(cim_in12[i]), .cim_in13(cim_in13[i]), .cim_in14(cim_in14[i]), .cim_in15(cim_in15[i])
    );
  end
endgenerate


always @ (*) begin
  case (state)
    S1: begin
        chip = K_address[10:5];
        d0[chip] = K_input[8 * istep +: 7];
        d1[chip] = K_input[8 * (istep + 32) +: 7];
        d2[chip] = K_input[8 * (istep + 64) +: 7];
        d3[chip] = K_input[8 * (istep + 96) +: 7];
        a[9 : 5] = istep;
        a[4 : 0] = K_address[4 : 0];
    end

    S2: begin
        chip = idx[10:5];
        cim_in0[chip] = Q_input[8*(ostep)+:7];
        cim_in1[chip] = Q_input[8*(ostep+8)+:7];
        cim_in2[chip] = Q_input[8*(ostep+16)+:7];
        cim_in3[chip] = Q_input[8*(ostep+24)+:7];
        cim_in4[chip] = Q_input[8*(ostep+32)+:7];
        cim_in5[chip] = Q_input[8*(ostep+40)+:7];
        cim_in6[chip] = Q_input[8*(ostep+48)+:7];
        cim_in7[chip] = Q_input[8*(ostep+56)+:7];
        cim_in8[chip] = Q_input[8*(ostep+64)+:7];
        cim_in9[chip] = Q_input[8*(ostep+72)+:7];
        cim_in10[chip] = Q_input[8*(ostep+80)+:7];
        cim_in11[chip] = Q_input[8*(ostep+88)+:7];
        cim_in12[chip] = Q_input[8*(ostep+96)+:7];
        cim_in13[chip] = Q_input[8*(ostep+104)+:7];
        cim_in14[chip] = Q_input[8*(ostep+112)+:7];
        cim_in15[chip] = Q_input[8*(ostep+120)+:7];
        a[4:0] = idx[4:0];
        a[7:5] = ostep[2:0];
        out_select = idx[4:2];
                case (out_select)
                    3'b000: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b001: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b010: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b011: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b100: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b101: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b110: begin
                        cim_out = cim_out0[chip];
                    end  
                    3'b111: begin
                        cim_out = cim_out0[chip];
                    end
                    default begin
                        cim_out = 8'b0;
                    end
                endcase
    end
  endcase
end

integer j;
reg prev_condition;

always @ (posedge clk or posedge reset) begin
    if (reset)
        state <= S0;
    else
        case (state)
            S0: begin
                if (K_mode_enable) begin
                    web <= 1;//低电平使能
                    cimeb <= 1;
                    istep <= 5'b0;
                    input_done <= 0;
                    output_done <= 0;
                    state <= S1;
                end 
                else if (Q_mode_enable) begin
                    web <= 1;
                    cimeb <= 0;
                    ostep <= 3'b000;
                    idx <= 11'b0;
                    input_done <= 0;
                    output_done <= 0;
                    state <= S2;
                    sum_total <= 8'b0;
                    for (j = 0 ; j < 2048 * 8 ; j = j + 1) begin
                        QK_output[j] <= 0;
                    end
                    cim_out <= 8'b0;
                    count = 0;
                    ostep_wait = 1;
                end
                else begin
                    web <= 1;
                    cimeb <= 1;
                end
            end
            S1: begin
                if (istep == 5'b11111) begin
                    state <= S0;
                    input_done <= 1;
                end
                web = ~web;
                if (web) begin
                    istep <= istep + 1;
                end
            end
            S2: begin
                web <= 1;
                cimeb <= 0;
                input_done <= 0;
                output_done <= 0;
                if (ostep == 3'b111) begin
                    if (idx == 11'b11111111111) begin
                        state <= S0;
                        output_done <= 1;
                    end
                    idx <= idx + 1;
                    ostep_wait <= 1;
                end
                if (ostep == 3'b000) begin
                    if (!ostep_wait) begin
                        ostep <= ostep + 1;
                    end 
                    else begin
                        ostep_wait <= ~ostep_wait;
                    end
                end
                else begin
                    ostep <= ostep + 1;
                end
                
                if(ostep_wait == 0)begin
                    if(ostep == 3'b000) begin
                        sum_total <= 8'b0;
                    end
                    else begin
                        sum_total <= sum_total + cim_out;
                    end
                end
                else begin
                    QK_output[idx*8 +: 7] <= sum_total + cim_out;
                    sum_total <= sum_total + cim_out;
                end


            end
            default: begin
                state <= S0;
            end
        endcase
end

endmodule