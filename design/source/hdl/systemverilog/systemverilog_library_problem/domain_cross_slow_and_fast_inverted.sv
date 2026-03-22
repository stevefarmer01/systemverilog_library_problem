/**
 * @file    domain_cross_slow_and_fast_different.sv
 * @author  Steve Farmer
 * @date    07 July 2022
 * @brief   Clock domain crossing
 * @note    Clock domain crossing of slow to fast OR fast to slow using the double register technique (number of registers parameterizeable)
 *          With ASYNC_REG Xilinx placement constraints to improve removal of metastability.
 *
 */

`timescale 1ns / 1ps

//If sync reset used then in Artix7 this appears to cause the registers to no longer be in the slice

module domain_cross_slow_and_fast_inverted
  #(
    parameter INPUT_WIDTH = 1,
    parameter NUMBER_OF_REGS = 2,
    parameter FAST_TO_SLOW_DOMAIN_CROSSING = 0
  )
  (
    input logic data_in_clk,    // This is always required even when not used in code below (FAST_TO_SLOW_DOMAIN_CROSSING = 0) because it is used for timing constraints in asscoiated file domain_cross_slow_and_fast_different.xdc
    input logic data_out_clk,
    //input logic reset,
    input logic [INPUT_WIDTH-1 : 0] data_in,
    output logic [INPUT_WIDTH-1 : 0] data_out = '0
  );

  logic [INPUT_WIDTH-1 : 0] shift_array_in = 0; // If this isn't initialed to 0 then line below with 'shift_array_in <= ~shift_array_in' in it won't work in behavioural simulation (initialises to 'X')
  (* ASYNC_REG = "TRUE" *) logic [NUMBER_OF_REGS-1 : 0] [INPUT_WIDTH-1 : 0] data_shift_array = '0;


  generate
  //      logic data_in_r;
  //      always_ff @(data_in_clk) data_in_r <= data_in;
  //      always_comb shift_array_in = data_in_r;

  //  if (FAST_TO_SLOW_DOMAIN_CROSSING == 0) begin
        always_comb shift_array_in = ~data_in;
  //  end
  //  else begin
  //      always_ff @(posedge data_in_clk) if (data_in) shift_array_in <= ~shift_array_in;
  //  end
  endgenerate

  always_ff @ (posedge data_out_clk)
      begin
  //    if (reset === 1) begin
  //        data_shift_array = '0;
  //    end else begin
      //        (* ASYNC_REG = "TRUE" *) reg [NUMBER_OF_REGS-1 : 0] data_shift_array; //This attribute doesn't appear to work in systemverliog on a variable but is does on a signal above
          data_shift_array <= {data_shift_array[$left(data_shift_array)-1 : 0], shift_array_in};
  //    end
  end

  generate
  //  if (FAST_TO_SLOW_DOMAIN_CROSSING == 0) begin
        always_comb data_out = data_shift_array[$left(data_shift_array)];
  //  end
  //  else begin
  //      always_ff @(posedge data_out_clk) data_out <= data_shift_array[$left(data_shift_array)] ^ data_shift_array[$left(data_shift_array)-1];
  //  end
  endgenerate

endmodule

