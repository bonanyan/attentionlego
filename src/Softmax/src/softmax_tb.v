
// softmax_tb.v
`timescale 1ns/1ns
`include "./src/softmax.v"

module testbench ();
reg clk, rst, en, we, cme;
reg [11:0] addr;
reg [255:0] cmIn;
wire [255:0] cmOut;
wire cmOutValid;
      
reg [255:0] cmOutExpected;

reg [31:0] correct;
reg all_correct;
      
initial begin
clk = 0;
#1;
forever #5 clk <= ~clk;
end

softmax32 softmax_mod (
    .clk(clk),
    .rst(rst),
    .en(en),
    .we(we),
    .cme(cme),
    .addr(addr),
    .cmIn(cmIn),
    .cmOut(cmOut),
    .cmOutValid(cmOutValid)
);
      
initial begin
en = 1;
rst = 1;
#100
rst = 0;
en = 1;
we = 1;
cme = 0;
addr = 0;
cmIn[1*8-1:0*8] = 247;
cmIn[2*8-1:1*8] = 112;
cmIn[3*8-1:2*8] = 1;
cmIn[4*8-1:3*8] = 233;
cmIn[5*8-1:4*8] = 240;
cmIn[6*8-1:5*8] = 149;
cmIn[7*8-1:6*8] = 171;
cmIn[8*8-1:7*8] = 21;
cmIn[9*8-1:8*8] = 196;
cmIn[10*8-1:9*8] = 60;
cmIn[11*8-1:10*8] = 7;
cmIn[12*8-1:11*8] = 201;
cmIn[13*8-1:12*8] = 88;
cmIn[14*8-1:13*8] = 159;
cmIn[15*8-1:14*8] = 157;
cmIn[16*8-1:15*8] = 38;
cmIn[17*8-1:16*8] = 46;
cmIn[18*8-1:17*8] = 29;
cmIn[19*8-1:18*8] = 3;
cmIn[20*8-1:19*8] = 124;
cmIn[21*8-1:20*8] = 247;
cmIn[22*8-1:21*8] = 16;
cmIn[23*8-1:22*8] = 138;
cmIn[24*8-1:23*8] = 119;
cmIn[25*8-1:24*8] = 153;
cmIn[26*8-1:25*8] = 22;
cmIn[27*8-1:26*8] = 148;
cmIn[28*8-1:27*8] = 69;
cmIn[29*8-1:28*8] = 142;
cmIn[30*8-1:29*8] = 165;
cmIn[31*8-1:30*8] = 123;
cmIn[32*8-1:31*8] = 90;

#100
en = 1;
we = 0;
cme = 1;

#100
cmOutExpected[1*8-1:0*8] = 18;
cmOutExpected[2*8-1:1*8] = 6;
cmOutExpected[3*8-1:2*8] = 2;
cmOutExpected[4*8-1:3*8] = 16;
cmOutExpected[5*8-1:4*8] = 17;
cmOutExpected[6*8-1:5*8] = 8;
cmOutExpected[7*8-1:6*8] = 10;
cmOutExpected[8*8-1:7*8] = 3;
cmOutExpected[9*8-1:8*8] = 12;
cmOutExpected[10*8-1:9*8] = 4;
cmOutExpected[11*8-1:10*8] = 2;
cmOutExpected[12*8-1:11*8] = 13;
cmOutExpected[13*8-1:12*8] = 5;
cmOutExpected[14*8-1:13*8] = 9;
cmOutExpected[15*8-1:14*8] = 9;
cmOutExpected[16*8-1:15*8] = 3;
cmOutExpected[17*8-1:16*8] = 3;
cmOutExpected[18*8-1:17*8] = 3;
cmOutExpected[19*8-1:18*8] = 2;
cmOutExpected[20*8-1:19*8] = 7;
cmOutExpected[21*8-1:20*8] = 18;
cmOutExpected[22*8-1:21*8] = 3;
cmOutExpected[23*8-1:22*8] = 8;
cmOutExpected[24*8-1:23*8] = 6;
cmOutExpected[25*8-1:24*8] = 9;
cmOutExpected[26*8-1:25*8] = 3;
cmOutExpected[27*8-1:26*8] = 8;
cmOutExpected[28*8-1:27*8] = 4;
cmOutExpected[29*8-1:28*8] = 8;
cmOutExpected[30*8-1:29*8] = 9;
cmOutExpected[31*8-1:30*8] = 7;
cmOutExpected[32*8-1:31*8] = 5;
correct[0] = cmOut[1*8-1:0*8] == cmOutExpected[1*8-1:0*8];
correct[1] = cmOut[2*8-1:1*8] == cmOutExpected[2*8-1:1*8];
correct[2] = cmOut[3*8-1:2*8] == cmOutExpected[3*8-1:2*8];
correct[3] = cmOut[4*8-1:3*8] == cmOutExpected[4*8-1:3*8];
correct[4] = cmOut[5*8-1:4*8] == cmOutExpected[5*8-1:4*8];
correct[5] = cmOut[6*8-1:5*8] == cmOutExpected[6*8-1:5*8];
correct[6] = cmOut[7*8-1:6*8] == cmOutExpected[7*8-1:6*8];
correct[7] = cmOut[8*8-1:7*8] == cmOutExpected[8*8-1:7*8];
correct[8] = cmOut[9*8-1:8*8] == cmOutExpected[9*8-1:8*8];
correct[9] = cmOut[10*8-1:9*8] == cmOutExpected[10*8-1:9*8];
correct[10] = cmOut[11*8-1:10*8] == cmOutExpected[11*8-1:10*8];
correct[11] = cmOut[12*8-1:11*8] == cmOutExpected[12*8-1:11*8];
correct[12] = cmOut[13*8-1:12*8] == cmOutExpected[13*8-1:12*8];
correct[13] = cmOut[14*8-1:13*8] == cmOutExpected[14*8-1:13*8];
correct[14] = cmOut[15*8-1:14*8] == cmOutExpected[15*8-1:14*8];
correct[15] = cmOut[16*8-1:15*8] == cmOutExpected[16*8-1:15*8];
correct[16] = cmOut[17*8-1:16*8] == cmOutExpected[17*8-1:16*8];
correct[17] = cmOut[18*8-1:17*8] == cmOutExpected[18*8-1:17*8];
correct[18] = cmOut[19*8-1:18*8] == cmOutExpected[19*8-1:18*8];
correct[19] = cmOut[20*8-1:19*8] == cmOutExpected[20*8-1:19*8];
correct[20] = cmOut[21*8-1:20*8] == cmOutExpected[21*8-1:20*8];
correct[21] = cmOut[22*8-1:21*8] == cmOutExpected[22*8-1:21*8];
correct[22] = cmOut[23*8-1:22*8] == cmOutExpected[23*8-1:22*8];
correct[23] = cmOut[24*8-1:23*8] == cmOutExpected[24*8-1:23*8];
correct[24] = cmOut[25*8-1:24*8] == cmOutExpected[25*8-1:24*8];
correct[25] = cmOut[26*8-1:25*8] == cmOutExpected[26*8-1:25*8];
correct[26] = cmOut[27*8-1:26*8] == cmOutExpected[27*8-1:26*8];
correct[27] = cmOut[28*8-1:27*8] == cmOutExpected[28*8-1:27*8];
correct[28] = cmOut[29*8-1:28*8] == cmOutExpected[29*8-1:28*8];
correct[29] = cmOut[30*8-1:29*8] == cmOutExpected[30*8-1:29*8];
correct[30] = cmOut[31*8-1:30*8] == cmOutExpected[31*8-1:30*8];
correct[31] = cmOut[32*8-1:31*8] == cmOutExpected[32*8-1:31*8];
all_correct = correct == -1;//check bits of "correct" are all 1s

if (!all_correct) begin
    $display("Result not expected: correctness %b", correct);
end else begin
    $display("Result all correct");
end

#10000
$finish;
end

initial begin
 $dumpfile("wave.vcd");
 $dumpvars(0,testbench);
end

endmodule


