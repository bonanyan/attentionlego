
  // softmax.v generated by gen.py

  // Softmax input data format: 8-bit fixed-point number, range [-1,1)
        
  
// Calculate an 8-bit exponential operation and output a 32-bit fixed-point number (16 bits before and after the decimal point)
module exp_function (in, out);
input [8-1:0] in;
output [32-1:0] out;

assign out = (in == 8'h00) ? 32'h00005e2d :
(in == 8'h01) ? 32'h00005eea :
(in == 8'h02) ? 32'h00005fa9 :
(in == 8'h03) ? 32'h00006069 :
(in == 8'h04) ? 32'h0000612a :
(in == 8'h05) ? 32'h000061ed :
(in == 8'h06) ? 32'h000062b2 :
(in == 8'h07) ? 32'h00006378 :
(in == 8'h08) ? 32'h00006440 :
(in == 8'h09) ? 32'h00006509 :
(in == 8'h0a) ? 32'h000065d4 :
(in == 8'h0b) ? 32'h000066a0 :
(in == 8'h0c) ? 32'h0000676e :
(in == 8'h0d) ? 32'h0000683e :
(in == 8'h0e) ? 32'h0000690f :
(in == 8'h0f) ? 32'h000069e2 :
(in == 8'h10) ? 32'h00006ab7 :
(in == 8'h11) ? 32'h00006b8d :
(in == 8'h12) ? 32'h00006c65 :
(in == 8'h13) ? 32'h00006d3f :
(in == 8'h14) ? 32'h00006e1a :
(in == 8'h15) ? 32'h00006ef7 :
(in == 8'h16) ? 32'h00006fd6 :
(in == 8'h17) ? 32'h000070b7 :
(in == 8'h18) ? 32'h00007199 :
(in == 8'h19) ? 32'h0000727d :
(in == 8'h1a) ? 32'h00007363 :
(in == 8'h1b) ? 32'h0000744b :
(in == 8'h1c) ? 32'h00007534 :
(in == 8'h1d) ? 32'h0000761f :
(in == 8'h1e) ? 32'h0000770d :
(in == 8'h1f) ? 32'h000077fc :
(in == 8'h20) ? 32'h000078ed :
(in == 8'h21) ? 32'h000079df :
(in == 8'h22) ? 32'h00007ad4 :
(in == 8'h23) ? 32'h00007bcb :
(in == 8'h24) ? 32'h00007cc3 :
(in == 8'h25) ? 32'h00007dbe :
(in == 8'h26) ? 32'h00007eba :
(in == 8'h27) ? 32'h00007fb9 :
(in == 8'h28) ? 32'h000080b9 :
(in == 8'h29) ? 32'h000081bc :
(in == 8'h2a) ? 32'h000082c0 :
(in == 8'h2b) ? 32'h000083c7 :
(in == 8'h2c) ? 32'h000084cf :
(in == 8'h2d) ? 32'h000085da :
(in == 8'h2e) ? 32'h000086e7 :
(in == 8'h2f) ? 32'h000087f5 :
(in == 8'h30) ? 32'h00008906 :
(in == 8'h31) ? 32'h00008a1a :
(in == 8'h32) ? 32'h00008b2f :
(in == 8'h33) ? 32'h00008c46 :
(in == 8'h34) ? 32'h00008d60 :
(in == 8'h35) ? 32'h00008e7c :
(in == 8'h36) ? 32'h00008f9a :
(in == 8'h37) ? 32'h000090ba :
(in == 8'h38) ? 32'h000091dd :
(in == 8'h39) ? 32'h00009302 :
(in == 8'h3a) ? 32'h00009429 :
(in == 8'h3b) ? 32'h00009552 :
(in == 8'h3c) ? 32'h0000967e :
(in == 8'h3d) ? 32'h000097ac :
(in == 8'h3e) ? 32'h000098dd :
(in == 8'h3f) ? 32'h00009a10 :
(in == 8'h40) ? 32'h00009b45 :
(in == 8'h41) ? 32'h00009c7d :
(in == 8'h42) ? 32'h00009db7 :
(in == 8'h43) ? 32'h00009ef4 :
(in == 8'h44) ? 32'h0000a033 :
(in == 8'h45) ? 32'h0000a175 :
(in == 8'h46) ? 32'h0000a2b9 :
(in == 8'h47) ? 32'h0000a3ff :
(in == 8'h48) ? 32'h0000a549 :
(in == 8'h49) ? 32'h0000a695 :
(in == 8'h4a) ? 32'h0000a7e3 :
(in == 8'h4b) ? 32'h0000a934 :
(in == 8'h4c) ? 32'h0000aa88 :
(in == 8'h4d) ? 32'h0000abde :
(in == 8'h4e) ? 32'h0000ad37 :
(in == 8'h4f) ? 32'h0000ae93 :
(in == 8'h50) ? 32'h0000aff2 :
(in == 8'h51) ? 32'h0000b153 :
(in == 8'h52) ? 32'h0000b2b7 :
(in == 8'h53) ? 32'h0000b41e :
(in == 8'h54) ? 32'h0000b587 :
(in == 8'h55) ? 32'h0000b6f4 :
(in == 8'h56) ? 32'h0000b863 :
(in == 8'h57) ? 32'h0000b9d6 :
(in == 8'h58) ? 32'h0000bb4b :
(in == 8'h59) ? 32'h0000bcc3 :
(in == 8'h5a) ? 32'h0000be3e :
(in == 8'h5b) ? 32'h0000bfbc :
(in == 8'h5c) ? 32'h0000c13d :
(in == 8'h5d) ? 32'h0000c2c1 :
(in == 8'h5e) ? 32'h0000c448 :
(in == 8'h5f) ? 32'h0000c5d2 :
(in == 8'h60) ? 32'h0000c75f :
(in == 8'h61) ? 32'h0000c8ef :
(in == 8'h62) ? 32'h0000ca83 :
(in == 8'h63) ? 32'h0000cc19 :
(in == 8'h64) ? 32'h0000cdb3 :
(in == 8'h65) ? 32'h0000cf50 :
(in == 8'h66) ? 32'h0000d0f0 :
(in == 8'h67) ? 32'h0000d294 :
(in == 8'h68) ? 32'h0000d43b :
(in == 8'h69) ? 32'h0000d5e5 :
(in == 8'h6a) ? 32'h0000d792 :
(in == 8'h6b) ? 32'h0000d943 :
(in == 8'h6c) ? 32'h0000daf7 :
(in == 8'h6d) ? 32'h0000dcaf :
(in == 8'h6e) ? 32'h0000de6a :
(in == 8'h6f) ? 32'h0000e029 :
(in == 8'h70) ? 32'h0000e1eb :
(in == 8'h71) ? 32'h0000e3b0 :
(in == 8'h72) ? 32'h0000e57a :
(in == 8'h73) ? 32'h0000e746 :
(in == 8'h74) ? 32'h0000e917 :
(in == 8'h75) ? 32'h0000eaeb :
(in == 8'h76) ? 32'h0000ecc2 :
(in == 8'h77) ? 32'h0000ee9e :
(in == 8'h78) ? 32'h0000f07d :
(in == 8'h79) ? 32'h0000f260 :
(in == 8'h7a) ? 32'h0000f446 :
(in == 8'h7b) ? 32'h0000f631 :
(in == 8'h7c) ? 32'h0000f81f :
(in == 8'h7d) ? 32'h0000fa11 :
(in == 8'h7e) ? 32'h0000fc07 :
(in == 8'h7f) ? 32'h0000fe01 :
(in == 8'h80) ? 32'h00010000 :
(in == 8'h81) ? 32'h00010202 :
(in == 8'h82) ? 32'h00010408 :
(in == 8'h83) ? 32'h00010612 :
(in == 8'h84) ? 32'h00010820 :
(in == 8'h85) ? 32'h00010a32 :
(in == 8'h86) ? 32'h00010c49 :
(in == 8'h87) ? 32'h00010e63 :
(in == 8'h88) ? 32'h00011082 :
(in == 8'h89) ? 32'h000112a5 :
(in == 8'h8a) ? 32'h000114cd :
(in == 8'h8b) ? 32'h000116f9 :
(in == 8'h8c) ? 32'h00011929 :
(in == 8'h8d) ? 32'h00011b5d :
(in == 8'h8e) ? 32'h00011d96 :
(in == 8'h8f) ? 32'h00011fd4 :
(in == 8'h90) ? 32'h00012216 :
(in == 8'h91) ? 32'h0001245c :
(in == 8'h92) ? 32'h000126a7 :
(in == 8'h93) ? 32'h000128f7 :
(in == 8'h94) ? 32'h00012b4b :
(in == 8'h95) ? 32'h00012da4 :
(in == 8'h96) ? 32'h00013001 :
(in == 8'h97) ? 32'h00013264 :
(in == 8'h98) ? 32'h000134cb :
(in == 8'h99) ? 32'h00013737 :
(in == 8'h9a) ? 32'h000139a8 :
(in == 8'h9b) ? 32'h00013c1e :
(in == 8'h9c) ? 32'h00013e98 :
(in == 8'h9d) ? 32'h00014118 :
(in == 8'h9e) ? 32'h0001439d :
(in == 8'h9f) ? 32'h00014627 :
(in == 8'ha0) ? 32'h000148b5 :
(in == 8'ha1) ? 32'h00014b49 :
(in == 8'ha2) ? 32'h00014de3 :
(in == 8'ha3) ? 32'h00015081 :
(in == 8'ha4) ? 32'h00015325 :
(in == 8'ha5) ? 32'h000155ce :
(in == 8'ha6) ? 32'h0001587c :
(in == 8'ha7) ? 32'h00015b2f :
(in == 8'ha8) ? 32'h00015de9 :
(in == 8'ha9) ? 32'h000160a7 :
(in == 8'haa) ? 32'h0001636b :
(in == 8'hab) ? 32'h00016635 :
(in == 8'hac) ? 32'h00016904 :
(in == 8'had) ? 32'h00016bd9 :
(in == 8'hae) ? 32'h00016eb3 :
(in == 8'haf) ? 32'h00017194 :
(in == 8'hb0) ? 32'h0001747a :
(in == 8'hb1) ? 32'h00017766 :
(in == 8'hb2) ? 32'h00017a57 :
(in == 8'hb3) ? 32'h00017d4f :
(in == 8'hb4) ? 32'h0001804d :
(in == 8'hb5) ? 32'h00018350 :
(in == 8'hb6) ? 32'h0001865a :
(in == 8'hb7) ? 32'h0001896a :
(in == 8'hb8) ? 32'h00018c80 :
(in == 8'hb9) ? 32'h00018f9c :
(in == 8'hba) ? 32'h000192be :
(in == 8'hbb) ? 32'h000195e7 :
(in == 8'hbc) ? 32'h00019916 :
(in == 8'hbd) ? 32'h00019c4b :
(in == 8'hbe) ? 32'h00019f87 :
(in == 8'hbf) ? 32'h0001a2c9 :
(in == 8'hc0) ? 32'h0001a612 :
(in == 8'hc1) ? 32'h0001a962 :
(in == 8'hc2) ? 32'h0001acb8 :
(in == 8'hc3) ? 32'h0001b014 :
(in == 8'hc4) ? 32'h0001b378 :
(in == 8'hc5) ? 32'h0001b6e2 :
(in == 8'hc6) ? 32'h0001ba54 :
(in == 8'hc7) ? 32'h0001bdcc :
(in == 8'hc8) ? 32'h0001c14b :
(in == 8'hc9) ? 32'h0001c4d1 :
(in == 8'hca) ? 32'h0001c85e :
(in == 8'hcb) ? 32'h0001cbf2 :
(in == 8'hcc) ? 32'h0001cf8e :
(in == 8'hcd) ? 32'h0001d331 :
(in == 8'hce) ? 32'h0001d6db :
(in == 8'hcf) ? 32'h0001da8c :
(in == 8'hd0) ? 32'h0001de45 :
(in == 8'hd1) ? 32'h0001e205 :
(in == 8'hd2) ? 32'h0001e5cd :
(in == 8'hd3) ? 32'h0001e99c :
(in == 8'hd4) ? 32'h0001ed73 :
(in == 8'hd5) ? 32'h0001f152 :
(in == 8'hd6) ? 32'h0001f539 :
(in == 8'hd7) ? 32'h0001f927 :
(in == 8'hd8) ? 32'h0001fd1d :
(in == 8'hd9) ? 32'h0002011c :
(in == 8'hda) ? 32'h00020522 :
(in == 8'hdb) ? 32'h00020930 :
(in == 8'hdc) ? 32'h00020d47 :
(in == 8'hdd) ? 32'h00021165 :
(in == 8'hde) ? 32'h0002158c :
(in == 8'hdf) ? 32'h000219bc :
(in == 8'he0) ? 32'h00021df3 :
(in == 8'he1) ? 32'h00022233 :
(in == 8'he2) ? 32'h0002267c :
(in == 8'he3) ? 32'h00022acd :
(in == 8'he4) ? 32'h00022f27 :
(in == 8'he5) ? 32'h0002338a :
(in == 8'he6) ? 32'h000237f5 :
(in == 8'he7) ? 32'h00023c6a :
(in == 8'he8) ? 32'h000240e7 :
(in == 8'he9) ? 32'h0002456d :
(in == 8'hea) ? 32'h000249fd :
(in == 8'heb) ? 32'h00024e95 :
(in == 8'hec) ? 32'h00025337 :
(in == 8'hed) ? 32'h000257e2 :
(in == 8'hee) ? 32'h00025c97 :
(in == 8'hef) ? 32'h00026155 :
(in == 8'hf0) ? 32'h0002661c :
(in == 8'hf1) ? 32'h00026aed :
(in == 8'hf2) ? 32'h00026fc8 :
(in == 8'hf3) ? 32'h000274ac :
(in == 8'hf4) ? 32'h0002799b :
(in == 8'hf5) ? 32'h00027e93 :
(in == 8'hf6) ? 32'h00028395 :
(in == 8'hf7) ? 32'h000288a1 :
(in == 8'hf8) ? 32'h00028db8 :
(in == 8'hf9) ? 32'h000292d8 :
(in == 8'hfa) ? 32'h00029803 :
(in == 8'hfb) ? 32'h00029d38 :
(in == 8'hfc) ? 32'h0002a278 :
(in == 8'hfd) ? 32'h0002a7c2 :
(in == 8'hfe) ? 32'h0002ad17 :
(in == 8'hff) ? 32'h0002b276 :
 0;
endmodule

  
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
assign cmInExp = cmInExp0 + cmInExp1 + cmInExp2 + cmInExp3 + cmInExp4 + cmInExp5 + cmInExp6 + cmInExp7 + cmInExp8 + cmInExp9 + cmInExp10 + cmInExp11 + cmInExp12 + cmInExp13 + cmInExp14 + cmInExp15 + cmInExp16 + cmInExp17 + cmInExp18 + cmInExp19 + cmInExp20 + cmInExp21 + cmInExp22 + cmInExp23 + cmInExp24 + cmInExp25 + cmInExp26 + cmInExp27 + cmInExp28 + cmInExp29 + cmInExp30 + cmInExp31;

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

wire [31:0] cmInExp0; exp_function exp0(.in(cmIn[8-1:0]),.out(cmInExp0));
wire [31:0] cmInExp1; exp_function exp1(.in(cmIn[16-1:8]),.out(cmInExp1));
wire [31:0] cmInExp2; exp_function exp2(.in(cmIn[24-1:16]),.out(cmInExp2));
wire [31:0] cmInExp3; exp_function exp3(.in(cmIn[32-1:24]),.out(cmInExp3));
wire [31:0] cmInExp4; exp_function exp4(.in(cmIn[40-1:32]),.out(cmInExp4));
wire [31:0] cmInExp5; exp_function exp5(.in(cmIn[48-1:40]),.out(cmInExp5));
wire [31:0] cmInExp6; exp_function exp6(.in(cmIn[56-1:48]),.out(cmInExp6));
wire [31:0] cmInExp7; exp_function exp7(.in(cmIn[64-1:56]),.out(cmInExp7));
wire [31:0] cmInExp8; exp_function exp8(.in(cmIn[72-1:64]),.out(cmInExp8));
wire [31:0] cmInExp9; exp_function exp9(.in(cmIn[80-1:72]),.out(cmInExp9));
wire [31:0] cmInExp10; exp_function exp10(.in(cmIn[88-1:80]),.out(cmInExp10));
wire [31:0] cmInExp11; exp_function exp11(.in(cmIn[96-1:88]),.out(cmInExp11));
wire [31:0] cmInExp12; exp_function exp12(.in(cmIn[104-1:96]),.out(cmInExp12));
wire [31:0] cmInExp13; exp_function exp13(.in(cmIn[112-1:104]),.out(cmInExp13));
wire [31:0] cmInExp14; exp_function exp14(.in(cmIn[120-1:112]),.out(cmInExp14));
wire [31:0] cmInExp15; exp_function exp15(.in(cmIn[128-1:120]),.out(cmInExp15));
wire [31:0] cmInExp16; exp_function exp16(.in(cmIn[136-1:128]),.out(cmInExp16));
wire [31:0] cmInExp17; exp_function exp17(.in(cmIn[144-1:136]),.out(cmInExp17));
wire [31:0] cmInExp18; exp_function exp18(.in(cmIn[152-1:144]),.out(cmInExp18));
wire [31:0] cmInExp19; exp_function exp19(.in(cmIn[160-1:152]),.out(cmInExp19));
wire [31:0] cmInExp20; exp_function exp20(.in(cmIn[168-1:160]),.out(cmInExp20));
wire [31:0] cmInExp21; exp_function exp21(.in(cmIn[176-1:168]),.out(cmInExp21));
wire [31:0] cmInExp22; exp_function exp22(.in(cmIn[184-1:176]),.out(cmInExp22));
wire [31:0] cmInExp23; exp_function exp23(.in(cmIn[192-1:184]),.out(cmInExp23));
wire [31:0] cmInExp24; exp_function exp24(.in(cmIn[200-1:192]),.out(cmInExp24));
wire [31:0] cmInExp25; exp_function exp25(.in(cmIn[208-1:200]),.out(cmInExp25));
wire [31:0] cmInExp26; exp_function exp26(.in(cmIn[216-1:208]),.out(cmInExp26));
wire [31:0] cmInExp27; exp_function exp27(.in(cmIn[224-1:216]),.out(cmInExp27));
wire [31:0] cmInExp28; exp_function exp28(.in(cmIn[232-1:224]),.out(cmInExp28));
wire [31:0] cmInExp29; exp_function exp29(.in(cmIn[240-1:232]),.out(cmInExp29));
wire [31:0] cmInExp30; exp_function exp30(.in(cmIn[248-1:240]),.out(cmInExp30));
wire [31:0] cmInExp31; exp_function exp31(.in(cmIn[256-1:248]),.out(cmInExp31));
// Memory write block
always @(posedge clk)
begin : MEM_WRITE
  if (!rst && en && we && !memValid[addr]) begin
    mem[{addr[11:5], 5'd0}] = cmInExp0;
mem[{addr[11:5], 5'd1}] = cmInExp1;
mem[{addr[11:5], 5'd2}] = cmInExp2;
mem[{addr[11:5], 5'd3}] = cmInExp3;
mem[{addr[11:5], 5'd4}] = cmInExp4;
mem[{addr[11:5], 5'd5}] = cmInExp5;
mem[{addr[11:5], 5'd6}] = cmInExp6;
mem[{addr[11:5], 5'd7}] = cmInExp7;
mem[{addr[11:5], 5'd8}] = cmInExp8;
mem[{addr[11:5], 5'd9}] = cmInExp9;
mem[{addr[11:5], 5'd10}] = cmInExp10;
mem[{addr[11:5], 5'd11}] = cmInExp11;
mem[{addr[11:5], 5'd12}] = cmInExp12;
mem[{addr[11:5], 5'd13}] = cmInExp13;
mem[{addr[11:5], 5'd14}] = cmInExp14;
mem[{addr[11:5], 5'd15}] = cmInExp15;
mem[{addr[11:5], 5'd16}] = cmInExp16;
mem[{addr[11:5], 5'd17}] = cmInExp17;
mem[{addr[11:5], 5'd18}] = cmInExp18;
mem[{addr[11:5], 5'd19}] = cmInExp19;
mem[{addr[11:5], 5'd20}] = cmInExp20;
mem[{addr[11:5], 5'd21}] = cmInExp21;
mem[{addr[11:5], 5'd22}] = cmInExp22;
mem[{addr[11:5], 5'd23}] = cmInExp23;
mem[{addr[11:5], 5'd24}] = cmInExp24;
mem[{addr[11:5], 5'd25}] = cmInExp25;
mem[{addr[11:5], 5'd26}] = cmInExp26;
mem[{addr[11:5], 5'd27}] = cmInExp27;
mem[{addr[11:5], 5'd28}] = cmInExp28;
mem[{addr[11:5], 5'd29}] = cmInExp29;
mem[{addr[11:5], 5'd30}] = cmInExp30;
mem[{addr[11:5], 5'd31}] = cmInExp31;
    memValid[addr] = 1;
    sum = sum + cmInExp;
  end
end

// Read result
always @(posedge clk)
begin : RESULT_READ
  if (!rst && en && !we && cme) begin
    cmOut[8-1:0] = mem[{addr[11:5], 5'd0}] / (sum >> 8);
cmOut[16-1:8] = mem[{addr[11:5], 5'd1}] / (sum >> 8);
cmOut[24-1:16] = mem[{addr[11:5], 5'd2}] / (sum >> 8);
cmOut[32-1:24] = mem[{addr[11:5], 5'd3}] / (sum >> 8);
cmOut[40-1:32] = mem[{addr[11:5], 5'd4}] / (sum >> 8);
cmOut[48-1:40] = mem[{addr[11:5], 5'd5}] / (sum >> 8);
cmOut[56-1:48] = mem[{addr[11:5], 5'd6}] / (sum >> 8);
cmOut[64-1:56] = mem[{addr[11:5], 5'd7}] / (sum >> 8);
cmOut[72-1:64] = mem[{addr[11:5], 5'd8}] / (sum >> 8);
cmOut[80-1:72] = mem[{addr[11:5], 5'd9}] / (sum >> 8);
cmOut[88-1:80] = mem[{addr[11:5], 5'd10}] / (sum >> 8);
cmOut[96-1:88] = mem[{addr[11:5], 5'd11}] / (sum >> 8);
cmOut[104-1:96] = mem[{addr[11:5], 5'd12}] / (sum >> 8);
cmOut[112-1:104] = mem[{addr[11:5], 5'd13}] / (sum >> 8);
cmOut[120-1:112] = mem[{addr[11:5], 5'd14}] / (sum >> 8);
cmOut[128-1:120] = mem[{addr[11:5], 5'd15}] / (sum >> 8);
cmOut[136-1:128] = mem[{addr[11:5], 5'd16}] / (sum >> 8);
cmOut[144-1:136] = mem[{addr[11:5], 5'd17}] / (sum >> 8);
cmOut[152-1:144] = mem[{addr[11:5], 5'd18}] / (sum >> 8);
cmOut[160-1:152] = mem[{addr[11:5], 5'd19}] / (sum >> 8);
cmOut[168-1:160] = mem[{addr[11:5], 5'd20}] / (sum >> 8);
cmOut[176-1:168] = mem[{addr[11:5], 5'd21}] / (sum >> 8);
cmOut[184-1:176] = mem[{addr[11:5], 5'd22}] / (sum >> 8);
cmOut[192-1:184] = mem[{addr[11:5], 5'd23}] / (sum >> 8);
cmOut[200-1:192] = mem[{addr[11:5], 5'd24}] / (sum >> 8);
cmOut[208-1:200] = mem[{addr[11:5], 5'd25}] / (sum >> 8);
cmOut[216-1:208] = mem[{addr[11:5], 5'd26}] / (sum >> 8);
cmOut[224-1:216] = mem[{addr[11:5], 5'd27}] / (sum >> 8);
cmOut[232-1:224] = mem[{addr[11:5], 5'd28}] / (sum >> 8);
cmOut[240-1:232] = mem[{addr[11:5], 5'd29}] / (sum >> 8);
cmOut[248-1:240] = mem[{addr[11:5], 5'd30}] / (sum >> 8);
cmOut[256-1:248] = mem[{addr[11:5], 5'd31}] / (sum >> 8);
    cmOutValid = 1;
  end
end

endmodule

  
