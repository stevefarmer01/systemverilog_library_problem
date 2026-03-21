//Language: System Verilog 2009


`timescale 1ns / 1ps

`include "generic_axi_axis_ip_svh.svh"
`include "axis_svh.svh"
//import generic_axi_axis_ip_pkg::*;

module generic_axi_axis_ip_axis
  #(
    parameter REMOVE_AXIS_BYPASS_MODULES = 0,         // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
    parameter DATA_WIDTH = 64,                        // Width of AXI stream interfaces in bits
    parameter KEEP_ENABLE = 0,                        // Propagate tkeep signal                                                                                                                                                                                                                          // (DATA_WIDTH>8),
    parameter KEEP_WIDTH = (DATA_WIDTH/8),            // tkeep signal width (words per cycle)
    parameter LAST_ENABLE = 1,                        // Propagate tlast signal
    parameter ID_ENABLE = 0,                          // Propagate tid signal
    parameter ID_WIDTH = 8,                           // tid signal width
    parameter DEST_ENABLE = 0,                        // Propagate tdest signal
    parameter DEST_WIDTH = 8,                         // tdest signal width
    parameter USER_ENABLE = 1,                        // Propagate tuser signal
    parameter USER_WIDTH = 1//,                       // tuser signal width
  )
  (
    axi_stream_if.axi_stream_slave_modport generic_axi_axis_ip_axis_slave,
    axi_stream_if.axi_stream_master_modport generic_axi_axis_ip_axis_master,
    axi_reg_map_if.reg_map_slave_modport axi_register_map_slave
  );

  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  to_module_axi_stream_if   (generic_axi_axis_ip_axis_slave.clk, generic_axi_axis_ip_axis_slave.resetn);
  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  pre_processing_module_axi_stream_if (generic_axi_axis_ip_axis_slave.clk, generic_axi_axis_ip_axis_slave.resetn);
  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  post_processing_module_axi_stream_if (generic_axi_axis_ip_axis_slave.clk, generic_axi_axis_ip_axis_slave.resetn);
  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  from_module_axi_stream_if (generic_axi_axis_ip_axis_slave.clk, generic_axi_axis_ip_axis_slave.resetn);

  generic_axi_axis_ip_axis_bypass_if 
  #(
    .REMOVE_AXIS_BYPASS_MODULES(REMOVE_AXIS_BYPASS_MODULES), // parameter REMOVE_AXIS_BYPASS_MODULES = 0,                    // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
    .DATA_WIDTH(DATA_WIDTH),                                 // parameter DATA_WIDTH = `default_DATA_WIDTH,                  // Width of AXI stream interfaces in bits
    .USER_ENABLE(USER_ENABLE)                                // parameter USER_ENABLE = 1                                    // Propagate tuser signal
  )
  top_axis_bypass_inst 
  (
    .axi_stream_slave(generic_axi_axis_ip_axis_slave),        // axi_stream_if.axi_stream_slave_modport axi_stream_slave,
    .axi_stream_master_0(to_module_axi_stream_if),          // axi_stream_if.axi_stream_master_modport axi_stream_master_0,
    .axi_stream_slave_0(from_module_axi_stream_if),         // axi_stream_if.axi_stream_slave_modport axi_stream_slave_0,
    .axi_stream_master(generic_axi_axis_ip_axis_master),      // axi_stream_if.axi_stream_master_modport axi_stream_master,
    .bypass(axi_register_map_slave.bypass_everything)       // input  logic [$clog2(S_COUNT)-1:0]    bypass
  );

  generic_axi_axis_ip_axis_reset_srl_register_reg_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH)
  axis_srl_register_0_inst 
  (
    .axi_stream_slave(to_module_axi_stream_if),             // axi_stream_if.axi_stream_slave_modport axi_stream_slave
    .axi_stream_master(pre_processing_module_axi_stream_if)           // axi_stream_if.axi_stream_master_modport axi_stream_master,
  );

  always_comb begin
//  post_processing_module_axi_stream_if.tdata = bit'(pre_processing_module_axi_stream_if.tdata)+1; //remove all X's and Z's by casting these can get propergated through if any bits of input AXIS is not driven by testbench
    post_processing_module_axi_stream_if.tdata = pre_processing_module_axi_stream_if.tdata; //remove all X's and Z's by casting these can get propergated through if any bits of input AXIS is not driven by testbench
    post_processing_module_axi_stream_if.tkeep = pre_processing_module_axi_stream_if.tkeep;
    post_processing_module_axi_stream_if.tvalid = pre_processing_module_axi_stream_if.tvalid;
    pre_processing_module_axi_stream_if.tready = post_processing_module_axi_stream_if.tready;
    post_processing_module_axi_stream_if.tlast = pre_processing_module_axi_stream_if.tlast;
    post_processing_module_axi_stream_if.tid = pre_processing_module_axi_stream_if.tid;
    post_processing_module_axi_stream_if.tdest = pre_processing_module_axi_stream_if.tdest;
    post_processing_module_axi_stream_if.tuser = pre_processing_module_axi_stream_if.tuser;
  end

  generic_axi_axis_ip_axis_reset_srl_register_reg_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH)
  axis_srl_register_1_inst 
  (
    .axi_stream_slave(post_processing_module_axi_stream_if),             // axi_stream_if.axi_stream_slave_modport axi_stream_slave
    .axi_stream_master(from_module_axi_stream_if)           // axi_stream_if.axi_stream_master_modport axi_stream_master,
  );

endmodule

