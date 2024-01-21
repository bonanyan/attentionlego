`timescale 1ns/1ns
`include "total_cim.v"

module testbench ();

reg clk, cs, reset, K_mode_enable, Q_mode_enable;
reg [10 : 0] addr;
reg [128 * 8 - 1 : 0] K_input, Q_input;

wire input_done, output_done;
wire [2048 * 8 - 1 : 0] QK_output;
reg [2048 * 8 - 1 : 0] QK_output_correct;

reg [128*8 - 1 : 0] data_tmp;
reg [128*8 - 1 : 0] K_matrix [0:2047];

reg err_flag_Kinput = 0;
reg err_flag_QKoutput = 0;

initial begin
reset = 0;
cs = 0;
# 10;
cs = 1;
end

initial begin
clk = 0;
#1;
forever #5 clk <= ~clk;
end

integer i;

initial begin
// initialization
#11
err_flag_Kinput = 0;
addr = -1;
K_mode_enable = 0;
Q_mode_enable = 0;

//K_mode (K matrix storage) test
repeat(2048) begin
    #10
    addr = addr + 1;
    K_mode_enable = 1;
    
    for (i = 0 ; i < 1024 ; i = i + 1) begin
        K_input[i] <= $random;
    end
    K_matrix[addr] <= K_input;
    #10
    K_mode_enable <= 0;
    #800;
end

//Q_mode (QK compute) test
addr = -1;
K_mode_enable = 0;
Q_mode_enable = 0;

repeat (2) begin
    #10
    Q_mode_enable = 1;

    for (i = 0 ; i < 1024 ; i = i + 1) begin
        Q_input[i] <= $random;
    end
    #10
    Q_mode_enable = 0;
    #200000;
end

//finish
$finish;
end

QK_compute QKc(
    .input_done(input_done),//1 bit
    .output_done(output_done),//1 bit
    .QK_output(QK_output),//2048 * 8 bit
    .clk(clk),//1 bit
    .cs(cs),//1 bit
    .reset(reset),//1 bit
    .K_mode_enable(K_mode_enable),
    .Q_mode_enable(Q_mode_enable),
    .K_address(addr),//11 bit
    .K_input(K_input),//128 * 8 bit
    .Q_input(Q_input)//128 * 8 bit
);

initial begin
    $dumpfile("totalcim_wave.vcd");
    $dumpvars(0,testbench);
end

endmodule