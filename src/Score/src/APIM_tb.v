`timescale 1ns/1ns
`include "APIM.v"
//要运行这个tb文件，需要把APIM,v中的CIM_INPUT_PRECISION = 4，ADC_PRECISION = 6
module testbench ();

reg clk,cs,web,cimeb;
reg [9:0] a;
reg [7:0] d;
reg [3:0] cim_in0, cim_in1, cim_in2, cim_in3;

wire [7:0] q;
wire [5:0] cim_out0, cim_out1, 
		   cim_out2, cim_out3, 
		   cim_out4, cim_out5, 
		   cim_out6, cim_out7;
reg [13:0] cim_out0_correct;

reg [7:0] wr_data, rd_data;
reg err_flag = 0;
reg err_flag_cim = 0;

reg [7:0] data [0:1023];

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

// initial
// $monitor($realtime,,"web=%x,a=%x,d=%x,q=%x",web,a,d,q);

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
	wr_data = $random;
	data[a] = wr_data;
	d = wr_data;
	
	#10 
	web = 1;

	#10 
	rd_data = q;

	if (wr_data!=rd_data) begin 
		err_flag = 1;
		$display ("ERROR, Addr 0x%0x, Data 0x%0x != 0x%0x",a, wr_data, rd_data);	
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
	cim_in3 = $random;

	cim_out0_correct  = cim_in0 * data[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in1 * data[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in2 * data[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in3 * data[{2'b11,a[7:5],3'd0,a[1:0]}];

	#10 
	cimeb = 1;

	if (cim_out0_correct[13:8]!=cim_out0) begin 
		err_flag_cim = 1;
		$display ("ERROR, Addr 0x%0x, Data 0x%0x != 0x%0x",a, wr_data, rd_data);	
		end
end

if (err_flag_cim) 
	$display ("################### ERROR ############");
else  
	$display ("################### CIM Mode Passed at %0d ns ######################",$time);

// finish
$finish;
end


// instantiation
Basic_GeMM_CIM iapim (
	 .q (q)
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
	,.d (d)	
	,.cim_in0 (cim_in0)
	,.cim_in1 (cim_in1)
	,.cim_in2 (cim_in2)
	,.cim_in3 (cim_in3)
);

initial begin
 $dumpfile("APIM_wave.vcd");
 $dumpvars(0,testbench);
end

endmodule
