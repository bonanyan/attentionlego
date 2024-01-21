`timescale 1ps / 1ps
`include "src/apim.v"

module Basic_GeMM_CIM_tb;

  // Signal Declarations
  reg clk;
  reg [`ADDR_WIDTH-1:0] addr;
  reg cs;
  reg web;
  reg cimeb;
  reg [`DATA_WIDTH-1:0] mem_write_data;
  reg [`CIM_INPUT_PRECISION*`CIM_INPUT_PARALLELISM-1:0] cim_in;
  wire [`DATA_WIDTH-1:0] mem_read_data;
  wire [`ADC_PRECISION*`CIM_OUTPUT_PARALLELISM-1:0] cim_out;

  // Instantiate the DUT (Device Under Test)
  Basic_GeMM_CIM DUT (
    .clk(clk),
    .addr(addr),
    .cs(cs),
    .web(web),
    .cimeb(cimeb),
    .mem_write_data(mem_write_data),
    .cim_in(cim_in),
    .mem_read_data(mem_read_data),
    .cim_out(cim_out)
  );

  // Clock Generation
  always #5 clk = ~clk; // Toggle clock every 5 ns

  integer i;

  // Initial Block for Test Stimuli
  initial begin        
    $dumpfile("wave.vcd");  // generate wave.vcd
    $dumpvars(0, Basic_GeMM_CIM_tb);   // dump all of the TB module data
    
    // Initialize Inputs
    clk = 1;
    addr = 0;
    cs = 0;
    web = 1;
    cimeb = 1;
    mem_write_data = 0;
    cim_in = 0;

    // init memory
    #10
    cs = 1;  // Enable chip select
    web = 0; // Enable write operation

    addr = {4'd0,3'd0,4'd0,3'd0};
    mem_write_data = 0;
    #10

    // ---------------TEST WRITE-----------------
    for (i = 0; i < `RAM_DEPTH; i = i + 1) begin
        addr = i;
        // mem_write_data = 0; // Data to write (zeros)
        mem_write_data = $random; // Data to write (random numbers)
        #10;  // Wait for a bit (adjust as needed)
    end
    web = 1; // Disable write operation
    $display("Memory initialization complete at time = %t", $time);

    // ---------------TEST READ-----------------
    #100;

    for (i = 0; i < `RAM_DEPTH; i = i + 1) begin
        addr = i;
        cs = 1; web = 1;  cimeb = 1;
        #10;  // Wait for a bit (adjust as needed)
    end

    // ---------------TEST CIM-----------------
    #100;
    cs = 1; web = 1; cimeb = 0;
    addr = {4'd0,3'd0,4'd0,3'd0}; 
    cim_in = {4'b0001,4'b0001,4'b0001,4'b0001,
            4'b0001,4'b0001,4'b0001,4'b0001,
            4'b0001,4'b0001,4'b0001,4'b0001,
            4'b0001,4'b0001,4'b0001,4'b0001};
    #20;
    $display("01 Time = %t, addr = %b, mem_read_data = %b, cim_out = %b", $time, addr, mem_read_data, cim_out);
    #40;

    cs = 1; web = 1; cimeb = 0;
    addr = {4'd0,3'd0,4'd0,3'd0}; 
    cim_in = {4'b1010,4'b1010,4'b1010,4'b1010,
            4'b1010,4'b1010,4'b1010,4'b1010,
            4'b1010,4'b1010,4'b1010,4'b1010,
            4'b1010,4'b1010,4'b1010,4'b1010};
    #20;
    $display("02 Time = %t, addr = %b, mem_read_data = %b, cim_out = %b", $time, addr, mem_read_data, cim_out);
    #40;
    cs = 1; web = 1; cimeb = 0;
    cim_in = {4'b0010,4'b0010,4'b0010,4'b0010,
            4'b0010,4'b0010,4'b0010,4'b0010,
            4'b0010,4'b0010,4'b0010,4'b0010,
            4'b0010,4'b0010,4'b0010,4'b0010};
    #20;
    $display("03 Time = %t, addr = %b, mem_read_data = %b, cim_out = %b", $time, addr, mem_read_data, cim_out);
    #40;
    cs = 1; web = 1; cimeb = 0;
    cim_in = {4'b0000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000};
    #20;
    $display("04 Time = %t, addr = %b, mem_read_data = %b, cim_out = %b", $time, addr, mem_read_data, cim_out);

    #40;
    cs = 1; web = 1; cimeb = 0;
    cim_in = {4'b1000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000,
            4'b0000,4'b0000,4'b0000,4'b0000};
    #20;
    $display("04 Time = %t, addr = %b, mem_read_data = %b, cim_out = %b", $time, addr, mem_read_data, cim_out);
    #40;
    
    // Finish the simulation
    $finish;
  end

  // Monitor or Check Results
//   initial begin
//     $monitor("Time = %t, addr = %h, q = %h", $time, addr, q);
//   end

endmodule
