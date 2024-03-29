import math

# LUT verilog:
# assign y = (in == XXXX) ? x0 : (in == XXXX) ? x1 : ...
# or
# always @(*) begin if in == XXXX; out = YYYY; else if ...
# { chr(10).join(f"cmOut[{(i+1)*8}-1:{i*8}] = mem[{{addr[11:5], 5'd{i}}}] / (sum >> 8);" for i in range(32)) }

def module_exp_function():
  INPUT_WIDTH=8
  OUTPUT_WIDTH=32
  OUTPUT_FRACTIONAL=16

  assign_block = ''.join([
    "(in == 8'h{:02x}) ? 32'h{:08x} :\n".format(i, int(math.exp(-1. + i * 2 / 256.) * 2 ** 16))
    for i in range(256)
  ])

  return f"""
// Calculate an 8-bit exponential operation and output a 32-bit fixed-point number (16 bits before and after the decimal point)
module exp_function (in, out);
input [{INPUT_WIDTH}-1:0] in;
output [{OUTPUT_WIDTH}-1:0] out;

assign out = {assign_block} 0;
endmodule
"""

def module_softmax():
  return f'''
module softmax32 (
  clk,
  rst, // Reset to zero; All write operations should be performed after resetting, and each address can only be written once at most
  en, // Activate the module
  we, // Activate to write-in
  cme, // Activate the computation

  // sum, // For Test Purpose
  // mem, // For Test Purpose
  // memValid, // For Test Purpose

  addr, // ADDR_WIDTH bit Address
  cmIn, // Write a 32 * 8 bit fixed-point number input; The range of 8-bit fixed-point numbers is [-1,1)
  cmOut, // When cme=1, it outputs a fixed point number of 32 * 8 bits, representing the softmax value, with a range of [0,1)
  cmOutValid // When cme=1, it outputs a fixed point number of 32 * bits, which can also be understood as "done"
);

parameter 
	    DATA_WIDTH = 8,                // unit: bit
	    ADDR_WIDTH = 12,               // unit: bit
	     RAM_DEPTH = 1 << ADDR_WIDTH,
        IO_WIDTH = 32,               // IO_WIDTH*DATA_WIDTH bits
  INTERNAL_WIDTH = 32;

input clk;
input rst;
input en;
input we;
input cme;
input [ADDR_WIDTH-1:0] addr;
input [IO_WIDTH*DATA_WIDTH-1:0] cmIn;
output reg [IO_WIDTH*DATA_WIDTH-1:0] cmOut;
output reg cmOutValid;
integer i;


output reg [INTERNAL_WIDTH-1:0] mem [0:RAM_DEPTH-1];
output reg [0:0] memValid [0:RAM_DEPTH-1];
output reg [INTERNAL_WIDTH-1:0] sum;


wire [31:0] cmInExp;
assign cmInExp = { ' + '.join(f"cmInExp{i}" for i in range(32)) };

// Reset block
always @(posedge clk)
begin : RESET
  if (rst) begin
    for (i = 0; i < RAM_DEPTH; i = i + 1) begin
      memValid[i] = 0;
    end
    sum = 0;
  end
end

{ chr(10).join(f"wire [31:0] cmInExp{i}; exp_function exp{i}(.in(cmIn[{(i+1)*8}-1:{i*8}]),.out(cmInExp{i}));" for i in range(32)) }
// Memory write block
always @(posedge clk)
begin : MEM_WRITE
  if (!rst && en && we && !memValid[addr]) begin
    { chr(10).join(f"mem[{{addr[11:5], 5'd{i}}}] = cmInExp{i};" for i in range(32)) }
    memValid[addr] = 1;
    sum = sum + cmInExp;
  end
end

// Read result
always @(posedge clk)
begin : RESULT_READ
  if (!rst && en && !we && cme) begin
    { chr(10).join(f"cmOut[{(i+1)*8}-1:{i*8}] = mem[{{addr[11:5], 5'd{i}}}] / (sum >> 8);" for i in range(32)) }
    cmOutValid = 1;
  end
end

endmodule
'''

if __name__ == '__main__':
  print(f'''
  // softmax.v generated by gen.py

  // Softmax input data format: 8-bit fixed-point number, range [-1,1)
        
  {module_exp_function()}
  {module_softmax()}
  ''')