`include "APIM.v"
`include "constant.v"
module col_cim(
//output
      q0, q1, q2, q3,
      cim_out0,
      cim_out1,
      cim_out2,
      cim_out3,
      cim_out4,
      cim_out5,
      cim_out6,
      cim_out7,
//input
      clk,
      a,
      cs,
      web,
      cimeb,
      d0, d1, d2, d3,
      cim_in0,
      cim_in1,
      cim_in2,
      cim_in3,
      cim_in4,
      cim_in5,
      cim_in6,
      cim_in7,
      cim_in8,
      cim_in9,
      cim_in10,
      cim_in11,
      cim_in12,
      cim_in13,
      cim_in14,
      cim_in15
);
`define BIT_WIDTH 8
`define VOCAB_SIZE 32000
`define MAX_SEQUENCE_LENGTH 2048
`define N_HEADS 32
`define N_LAYERS 32
`define D_MODEL 4096
`define D_ff 11008 //hidden_dimension of MLP
`define D_k 128 //hidden_dimension of one head
//--------------Input Ports----------------------- 
input                  clk; //clk input
input [9:0]           a; //address, both effective in memory mode & CIM mode
input                  cs; //overall enable, chip select
input                  web; //write enable, low active
input                  cimeb; //CIM enable, low active
input [7:0]  d0, d1, d2, d3; //memory mode input data
input [7:0]  cim_in0, cim_in1, cim_in2, cim_in3, 
                       cim_in4, cim_in5, cim_in6, cim_in7,
                       cim_in8, cim_in9, cim_in10, cim_in11,
                       cim_in12, cim_in13, cim_in14, cim_in15;
//--------------Output Ports----------------------- 
output wire [7:0] q0, q1, q2, q3; //memory mode output data
output reg [7:0] cim_out0, cim_out1, cim_out2, cim_out3, cim_out4, cim_out5, cim_out6, cim_out7;

wire [7:0] cim0_out0, cim0_out1, cim0_out2, cim0_out3, cim0_out4, cim0_out5, cim0_out6, cim0_out7,
    cim1_out0, cim1_out1, cim1_out2, cim1_out3, cim1_out4, cim1_out5, cim1_out6, cim1_out7,
    cim2_out0, cim2_out1, cim2_out2, cim2_out3, cim2_out4, cim2_out5, cim2_out6, cim2_out7,
    cim3_out0, cim3_out1, cim3_out2, cim3_out3, cim3_out4, cim3_out5, cim3_out6, cim3_out7;

//--------Parameters-----------------

always @ (*)
begin
cim_out0 = cim0_out0 + cim1_out0 + cim2_out0 + cim3_out0;
cim_out1 = cim0_out1 + cim1_out1 + cim2_out1 + cim3_out1;
cim_out2 = cim0_out2 + cim1_out2 + cim2_out2 + cim3_out2;
cim_out3 = cim0_out3 + cim1_out3 + cim2_out3 + cim3_out3;
cim_out4 = cim0_out4 + cim1_out4 + cim2_out4 + cim3_out4;
cim_out5 = cim0_out5 + cim1_out5 + cim2_out5 + cim3_out5;
cim_out6 = cim0_out6 + cim1_out6 + cim2_out6 + cim3_out6;
cim_out7 = cim0_out7 + cim1_out7 + cim2_out7 + cim3_out7;
end



Basic_GeMM_CIM cim0(
    .q (q0)
	,.cim_out0 (cim0_out0)
	,.cim_out1 (cim0_out1)
	,.cim_out2 (cim0_out2)
	,.cim_out3 (cim0_out3)
	,.cim_out4 (cim0_out4)
	,.cim_out5 (cim0_out5)
	,.cim_out6 (cim0_out6)
	,.cim_out7 (cim0_out7)
	,.clk (clk)
	,.a (a)
	,.cs (cs)
	,.web (web)
	,.cimeb (cimeb)
	,.d (d0)	
	,.cim_in0 (cim_in0)
	,.cim_in1 (cim_in1)
	,.cim_in2 (cim_in2)
	,.cim_in3 (cim_in3)
);
Basic_GeMM_CIM cim1(
    .q (q1)
	,.cim_out0 (cim1_out0)
	,.cim_out1 (cim1_out1)
	,.cim_out2 (cim1_out2)
	,.cim_out3 (cim1_out3)
	,.cim_out4 (cim1_out4)
	,.cim_out5 (cim1_out5)
	,.cim_out6 (cim1_out6)
	,.cim_out7 (cim1_out7)
	,.clk (clk)
	,.a (a)
	,.cs (cs)
	,.web (web)
	,.cimeb (cimeb)
	,.d (d1)	
	,.cim_in0 (cim_in4)
	,.cim_in1 (cim_in5)
	,.cim_in2 (cim_in6)
	,.cim_in3 (cim_in7)
);
Basic_GeMM_CIM cim2(
    .q (q2)
	,.cim_out0 (cim2_out0)
	,.cim_out1 (cim2_out1)
	,.cim_out2 (cim2_out2)
	,.cim_out3 (cim2_out3)
	,.cim_out4 (cim2_out4)
	,.cim_out5 (cim2_out5)
	,.cim_out6 (cim2_out6)
	,.cim_out7 (cim2_out7)
	,.clk (clk)
	,.a (a)
	,.cs (cs)
	,.web (web)
	,.cimeb (cimeb)
	,.d (d2)	
	,.cim_in0 (cim_in8)
	,.cim_in1 (cim_in9)
	,.cim_in2 (cim_in10)
	,.cim_in3 (cim_in11)
);
Basic_GeMM_CIM cim3(
    .q (q3)
	,.cim_out0 (cim3_out0)
	,.cim_out1 (cim3_out1)
	,.cim_out2 (cim3_out2)
	,.cim_out3 (cim3_out3)
	,.cim_out4 (cim3_out4)
	,.cim_out5 (cim3_out5)
	,.cim_out6 (cim3_out6)
	,.cim_out7 (cim3_out7)
	,.clk (clk)
	,.a (a)
	,.cs (cs)
	,.web (web)
	,.cimeb (cimeb)
	,.d (d3)	
	,.cim_in0 (cim_in12)
	,.cim_in1 (cim_in13)
	,.cim_in2 (cim_in14)
	,.cim_in3 (cim_in15)
);
endmodule