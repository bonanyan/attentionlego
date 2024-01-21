//==================================================================================================
//  Filename      : Basic_GeMM_CIM.v
//  Created On    : 2022-10-07 08:17:17
//  Last Modified : 2022-12-27 11:05:50
//  Revision      : 
//  Author        : Bonan Yan
//  Company       : Peking University
//  Email         : bonanyan@pku.edu.cn
//
//  Description   : 
//
//
//==================================================================================================
module Basic_GeMM_CIM (
//output
      q,
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
      d,
      cim_in0,
      cim_in1,
      cim_in2,
      cim_in3
);

//Need to define the address map first and 
//change all of the following parameter accordingly
parameter 
	DATA_WIDTH = 8, // unit: bit
	ADDR_WIDTH = 10, // unit: bit

	ADC_PRECISION = 8, // unit: bit 原始数据为6，使用数据为8
	CIM_INPUT_PRECISION = 8, // unit: bit 原始数值为4，使用数据为8
	CIM_INPUT_PARALLELISM = 4, // unit: 1 (quantity)
	CIM_OUTPUT_PARALLELISM = 8; // unit: 1 (quantity)

//--------------Generated Parameters----------------------- 
parameter 
	RAM_DEPTH = 1 << ADDR_WIDTH;


//--------------Input Ports----------------------- 
input                  clk; //clk input
input [ADDR_WIDTH-1:0] a; //address, both effective in memory mode & CIM mode
input                  cs; //overall enable, chip select
input                  web; //write enable, low active
input                  cimeb; //CIM enable, low active
input [DATA_WIDTH-1:0] d; //memory mode input data
input [CIM_INPUT_PRECISION-1:0] cim_in0, cim_in1, cim_in2, cim_in3;


//--------------Output Ports----------------------- 
output reg [DATA_WIDTH-1:0] q; //memory mode output data
output [ADC_PRECISION-1:0] cim_out0, cim_out1, cim_out2, cim_out3, cim_out4, cim_out5, cim_out6, cim_out7;
//原：reg [ADC_PRECISION-1:0] cim_out0_tmp, cim_out1_tmp, cim_out2_tmp, cim_out3_tmp, cim_out4_tmp, cim_out5_tmp, cim_out6_tmp, cim_out7_tmp;
reg [15:0] cim_out0_tmp, cim_out1_tmp, cim_out2_tmp, cim_out3_tmp, cim_out4_tmp, cim_out5_tmp, cim_out6_tmp, cim_out7_tmp;

wire [15:0] cim_out0_wire, cim_out1_wire, cim_out2_wire, cim_out3_wire, cim_out4_wire, cim_out5_wire, cim_out6_wire, cim_out7_wire;
//--------------Internal variables---------------- 

reg [DATA_WIDTH-1:0] mem [0:RAM_DEPTH-1];

//--------------Code Starts Here------------------ 

// Memory Write Block 
// Write Operation : When we = 1, cs = 1
always @ (posedge clk)
begin : MEM_WRITE
   if ( cs && !web ) begin
       mem[a] = d;
   end
end

// Memory Read Block 
// Read Operation : When we = 0, oe = 1, cs = 1
always @ (posedge clk)
begin : MEM_READ
  if (cs && web) begin
    if(cimeb) begin
      q = mem[a];
    end else begin
      // enter cim mode
      cim_out0_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd0,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd0,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd0,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd0,a[1:0]}];
                
      cim_out1_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd1,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd1,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd1,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd1,a[1:0]}];
                
      cim_out2_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd2,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd2,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd2,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd2,a[1:0]}];
                
      cim_out3_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd3,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd3,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd3,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd3,a[1:0]}];
                
      cim_out4_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd4,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd4,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd4,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd4,a[1:0]}];
                
      cim_out5_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd5,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd5,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd5,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd5,a[1:0]}];
                
      cim_out6_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd6,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd6,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd6,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd6,a[1:0]}];
                
      cim_out7_tmp  = cim_in0 * mem[{2'b00,a[7:5],3'd7,a[1:0]}] 
                + cim_in1 * mem[{2'b01,a[7:5],3'd7,a[1:0]}] 
                + cim_in2 * mem[{2'b10,a[7:5],3'd7,a[1:0]}] 
                + cim_in3 * mem[{2'b11,a[7:5],3'd7,a[1:0]}];
    end
  end
end

assign cim_out0_wire = cim_out0_tmp;
assign cim_out1_wire = cim_out1_tmp;
assign cim_out2_wire = cim_out2_tmp;
assign cim_out3_wire = cim_out3_tmp;
assign cim_out4_wire = cim_out4_tmp;
assign cim_out5_wire = cim_out5_tmp;
assign cim_out6_wire = cim_out6_tmp;
assign cim_out7_wire = cim_out7_tmp;
assign cim_out0 = (cs && web && !cimeb) ? cim_out0_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out1 = (cs && web && !cimeb) ? cim_out1_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out2 = (cs && web && !cimeb) ? cim_out2_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out3 = (cs && web && !cimeb) ? cim_out3_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out4 = (cs && web && !cimeb) ? cim_out4_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out5 = (cs && web && !cimeb) ? cim_out5_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out6 = (cs && web && !cimeb) ? cim_out6_wire[15:15-ADC_PRECISION+1] : 8'b0;
assign cim_out7 = (cs && web && !cimeb) ? cim_out7_wire[15:15-ADC_PRECISION+1] : 8'b0;
//原始代码：上面的所有15换成13

endmodule // Basic_GeMM_CIM