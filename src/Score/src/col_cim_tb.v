`timescale 1ns/1ns
`include "col_cim.v"

module testbench ();

reg clk,cs,web,cimeb;
reg [9:0] a;
reg [7:0] d0, d1, d2, d3;
reg [7:0] cim_in0, cim_in1, cim_in2, cim_in3, 
          cim_in4, cim_in5, cim_in6, cim_in7,
          cim_in8, cim_in9, cim_in10, cim_in11,
          cim_in12, cim_in13, cim_in14, cim_in15;

wire [7:0] q0, q1, q2, q3;
wire [7:0] cim_out0, cim_out1, 
		   cim_out2, cim_out3, 
		   cim_out4, cim_out5, 
		   cim_out6, cim_out7;
reg [13:0] cim_out0_correct;

reg [7:0] wr_data0, rd_data0,
		  wr_data1, rd_data1,
		  wr_data2, rd_data2,
		  wr_data3, rd_data3;
reg err_flag = 0;
reg err_flag_cim = 0;

reg [7:0] data0 [0:1023];
reg [7:0] data1 [0:1023];
reg [7:0] data2 [0:1023];
reg [7:0] data3 [0:1023];

initial begin
cs = 0;
# 10;
cs = 1;
end

initial begin
clk = 0;
#1;
forever #5 clk <= ~clk;
end

initial begin
// initialization
#11 
err_flag = 0;
a = -1;
web = 1;
cimeb = 1;

// write & read test
repeat(1024) begin
	#10 
	a = a + 1;
	web = 0;
	wr_data0 = $random;
	data0[a] = wr_data0;
	d0 = wr_data0;
	wr_data1 = $random;
	data1[a] = wr_data1;
	d1 = wr_data1;
	wr_data2 = $random;
	data2[a] = wr_data2;
	d2 = wr_data2;
	wr_data3 = $random;
	data3[a] = wr_data3;
	d3 = wr_data3;
	
	#10 
	web = 1;

	#10 
	rd_data0 = q0;
	rd_data1 = q1;
	rd_data2 = q2;
	rd_data3 = q3;

	if (wr_data0!=rd_data0) begin 
		err_flag = 1;
		$display ("ERROR, Addr 0x%0x, Data0 0x%0x != 0x%0x",a, wr_data0, rd_data0);	
		end
	if (wr_data1!=rd_data1) begin 
		err_flag = 1;
		$display ("ERROR, Addr 0x%0x, Data1 0x%0x != 0x%0x",a, wr_data1, rd_data1);	
		end
	if (wr_data2!=rd_data2) begin 
		err_flag = 1;
		$display ("ERROR, Addr 0x%0x, Data2 0x%0x != 0x%0x",a, wr_data2, rd_data2);	
		end
	if (wr_data3!=rd_data3) begin 
		err_flag = 1;
		$display ("ERROR, Addr 0x%0x, Data3 0x%0x != 0x%0x",a, wr_data3, rd_data3);	
		end
end

if (err_flag) 
	$display ("################### ERROR ############");
else  
	$display ("################### Read/Write Mode Passed at %0d ns ######################",$time);

// cim mode test
#10
a = -1;
cimeb = 1;

repeat(1024) begin
	#10 
	a = a + 1;
	cimeb = 0;
	cim_in0 = $random;
	cim_in1 = $random;
	cim_in2 = $random;
	cim_in4 = $random;
	cim_in5 = $random;
	cim_in6 = $random;
	cim_in7 = $random;
	cim_in8 = $random;
	cim_in9 = $random;
	cim_in10 = $random;
	cim_in11 = $random;
	cim_in12 = $random;
	cim_in13 = $random;
	cim_in14 = $random;
	cim_in15 = $random;

	cim_out0_correct  = cim_in0 * data0[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in1 * data0[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in2 * data0[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in3 * data0[{2'b11,a[7:5],3'd0,a[1:0]}]
				+ cim_in4 * data1[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in5 * data1[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in6 * data1[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in7 * data1[{2'b11,a[7:5],3'd0,a[1:0]}]
				+ cim_in8 * data2[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in9 * data2[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in10 * data2[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in11 * data2[{2'b11,a[7:5],3'd0,a[1:0]}]
				+ cim_in12 * data3[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in13 * data3[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in14 * data3[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in15 * data3[{2'b11,a[7:5],3'd0,a[1:0]}];

	#10 
	cimeb = 1;

	if (cim_out0_correct[13:8] != cim_out0) begin 
		err_flag_cim = 1;
		//$display ("ERROR, Addr 0x%0x, Data 0x%0x != 0x%0x",a, wr_data, rd_data);	
		end
end

if (err_flag_cim) 
	$display ("################### ERROR ############");
else  
	$display ("################### CIM Mode Passed at %0d ns ######################",$time);

// finish
$finish;
end

col_cim colc (
	 .q0 (q0), .q1 (q1), .q2 (q2), .q3 (q3)
	,.cim_out0 (cim_out0)
	,.cim_out1 (cim_out1)
	,.cim_out2 (cim_out2)
	,.cim_out3 (cim_out3)
	,.cim_out4 (cim_out4)
	,.cim_out5 (cim_out5)
	,.cim_out6 (cim_out6)
	,.cim_out7 (cim_out7)
	,.clk (clk)
	,.a (a)
	,.cs (cs)
	,.web (web)
	,.cimeb (cimeb)
	,.d0 (d0)	,.d1 (d1)	,.d2 (d2)	,.d3 (d3)	
	,.cim_in0 (cim_in0)
	,.cim_in1 (cim_in1)
	,.cim_in2 (cim_in2)
	,.cim_in3 (cim_in3)
	,.cim_in4 (cim_in4)
	,.cim_in5 (cim_in5)
	,.cim_in6 (cim_in6)
	,.cim_in7 (cim_in7)
	,.cim_in8 (cim_in8)
	,.cim_in9 (cim_in9)
	,.cim_in10 (cim_in10)
	,.cim_in11 (cim_in11)
	,.cim_in12 (cim_in12)
	,.cim_in13 (cim_in13)
	,.cim_in14 (cim_in14)
	,.cim_in15 (cim_in15)
);

initial begin
 $dumpfile("colcim_wave.vcd");
 $dumpvars(0,testbench);
end

endmodule
