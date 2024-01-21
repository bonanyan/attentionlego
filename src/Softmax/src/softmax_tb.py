import random
import math

# for duplicatable results
random.seed(1234) 

# Randomly generate 32 uniform variables
inp = [random.random()*2-1 for i in range(32)]
inpu8 = [int((x+1)*128) for x in inp]

# Do softmax
expsum = sum(math.exp(x) for x in inp)
out = [math.exp(x) / expsum for x in inp]
outu8 = [int(x*256) for x in out]

print(f'''
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
{ chr(10).join(f"cmIn[{i+1}*8-1:{i}*8] = {inpu8[i]};" for i in range(32)) }

#100
en = 1;
we = 0;
cme = 1;

#100
{ chr(10).join(f"cmOutExpected[{i+1}*8-1:{i}*8] = {outu8[i]};" for i in range(32)) }
{ chr(10).join(f"correct[{i}] = cmOut[{i+1}*8-1:{i}*8] == cmOutExpected[{i+1}*8-1:{i}*8];" for i in range(32)) }
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

''')