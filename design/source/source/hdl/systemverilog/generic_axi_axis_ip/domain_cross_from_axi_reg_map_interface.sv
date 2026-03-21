`timescale 1ns / 1ps

//If sync reset used then in Artix7 this appears to cause the registers to no longer be in the slice

`include "generic_axi_axis_ip_svh.svh"

module domain_cross_from_axi_reg_map_interface
  #( 
    parameter NUMBER_OF_REGS = 2
  )
  (
    axi_reg_map_if.reg_map_slave_modport  axi_register_map_slave,
    axi_reg_map_if.reg_map_master_modport axi_register_map_axis_master,
    axi_reg_map_if.reg_map_master_modport axi_register_map_top_master
  );

  //Domain cross signals on interface axi_register_map_axis_master from/to AXIS clk (AXIStream) to/from AXI clk (AXILITE register map)
  domain_cross_slow_and_fast
  #($size(axi_register_map_slave.bypass_everything), NUMBER_OF_REGS, 0)
  bypass_everything_axi_stream_if_clk_inst
  (
    .data_in_clk(axi_register_map_slave.clk),                 // input logic data_in_clk,
    .data_out_clk(axi_register_map_axis_master.clk),          // input logic data_out_clk,
    .data_in(axi_register_map_slave.bypass_everything),       // input logic [INPUT_WIDTH-1 : 0] data_in,
    .data_out(axi_register_map_axis_master.bypass_everything) // output logic [INPUT_WIDTH-1 : 0] data_out = '0
  );

  //Domain cross signals on interface axi_register_map_top_master from/to top level firmware clk domain to/from AXI clk (AXILITE register map) NOT REQUIRED FOR CONSTANTS or values on AXI clk domain
  always_comb begin : CONNECT_DISCRETE_SIGNALS_TO_REG_MAP
    axi_register_map_slave.status_present = axi_register_map_top_master.status_present;
  end : CONNECT_DISCRETE_SIGNALS_TO_REG_MAP

endmodule

