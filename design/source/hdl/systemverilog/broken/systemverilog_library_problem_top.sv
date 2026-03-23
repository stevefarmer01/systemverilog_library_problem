`timescale 1ns / 1ps

module systemverilog_library_problem_top
  #(
    parameter INPUT_WIDTH = 2,
    parameter NUMBER_OF_REGS = 10
  )
  (
    input logic clk,
    //input logic reset,
    input logic [INPUT_WIDTH-1 : 0] data_in,
    output logic [INPUT_WIDTH-1 : 0] data_out // = '0
  );

  domain_cross_slow_and_fast
  #(
  .NUMBER_OF_REGS(NUMBER_OF_REGS)                                                // parameter NUMBER_OF_REGS = 2
  )
  domain_cross_slow_and_fast_inst_0
  (
    .data_in_clk(clk),     // input logic data_in_clk,
    .data_out_clk(clk),    // input logic data_out_clk,
    .data_in(data_in[0]),  // input logic [INPUT_WIDTH-1 : 0] data_in,
    .data_out(data_out[0]) // output logic [INPUT_WIDTH-1 : 0] data_out = '0
  );

  domain_cross_slow_and_fast_inverted
  #(
  .NUMBER_OF_REGS(NUMBER_OF_REGS)                                                // parameter NUMBER_OF_REGS = 2
  )
  domain_cross_slow_and_fast_inverted_inst_0
  (
    .data_in_clk(clk),     // input logic data_in_clk,
    .data_out_clk(clk),    // input logic data_out_clk,
    .data_in(data_in[1]),  // input logic [INPUT_WIDTH-1 : 0] data_in,
    .data_out(data_out[1]) // output logic [INPUT_WIDTH-1 : 0] data_out = '0
  );


endmodule

