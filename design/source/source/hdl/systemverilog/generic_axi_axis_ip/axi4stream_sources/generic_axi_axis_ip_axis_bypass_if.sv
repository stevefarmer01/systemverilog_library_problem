/**
 * @file    generic_axi_axis_ip_axis_bypass_if.sv
 * @author  Steve Farmer
 * @date    06 July 2022
 * @brief   Module that will bypass a module that has AXI4-Stream (AXIS) slave and masters ports
 * @note    Uses module 'axis_mux_reg.v' which is slightly modified 'axis_mux.v' from (https://github.com/alexforencich/verilog-axis).
 */

//Language: System Verilog 2009

// wrapper to convert into a 'bypass' the module 'axis_mux.v' from..
//              https://github.com/alexforencich/verilog-axis.git
// ..into a bypass of an external AXIS block
//
// This block will be used for bypassing AXIS blocks in a AXIS system primarily for diagnostics/simulation/hardware testing
//
// Before instantiation of this module.....
//
//         
//                                         +--------------+
//                                         |              |
//                      s_axis  +--------->+  AXIS block  +--------->   m_axis
//                                         |              |
//                                         +--------------+
//         
//         
//         
//         
//         
//         
//         
//  After.......      
//
//                                 All AXIS signals routing apart from tready
//                                 ------------------------------------------
//         
//                                          +--------------+
//                                          |              |
//          s_axis+->            +--------->+  AXIS block  +--------->            +->m_axis
//                  |            ^          |              |         |            ^
//                  |            |          +--------------+         |            |
//                  |            |                                   |            |
//                  v            +                                   v            +
//      axi_stream_slave     axi_stream_master_0        axi_stream_slave_0     axi_stream_master
//          
//                  +                                                +
//                  |                                                |            ^
//                  |                                                |            |
//                  |                                                |    +       |
//                  |                                                |    | \ +   |
//                  |                                                v    |   |   |
//                  |                                                +----+ 0 |   |
//                  v                                                     |   +---+
//                  +-----------------------------------------------------+ 1 |
//                                                                        |   |
//                                                                        | / +
//                                                                        +
//                                                                          ^
//                                                                          |
//                                                                          +
//                                                                         bypass
//
//
//
//                                             tready AXIS signal routing
//                                             --------------------------
//         
//                                                   +--------------+
//                                                   |              |
//  s_axis_tready <-+                     <----------+  AXIS block  +<--------+            +--< m_axis_tready
//                  ^                     |          |              |         ^            ^
//                  |                     |          +--------------+         |            |
//                  |                     |                                   |            |
//                  +                     v                                   +            +
//  axi_stream_slave.tready  axi_stream_master_0.tready   axi_stream_slave_0.tready   axi_stream_master.tready
//                                                                                                            
//                  ^                     +                                   ^            +                  
//                  |                     |                                   |            |                         
//                  |       +             |                                   |        +   |                                            
//                  |   + / |             |                                   |    + / |   |                               
//                  |   |   |             v                                   |    |   |   |          
//                  |   | 0 +<------------+                                   +---<+ 0 |   v                   
//                  +--<+   |                                                      |   +<--+                  
//                      | 1 +<------------------ s_axis_in_tready_mux ------------<+ 1 |                     
//                      |   |                                                      |   |                                                                 
//                      + \ |                                                      + \ |                          
//                          +                                                          +                          
//                        ^                                                          ^                           
//                        |                                                          |                           
//                        +                                                          +                                                
//                       bypass                                                     bypass                                                    
//                                                                                                          
         

// See comments at bottom of code for example of how to instantiate this module

`timescale 1ns / 1ps

`include "axis_svh.svh"

module generic_axi_axis_ip_axis_bypass_if #
(
    parameter REMOVE_AXIS_BYPASS_MODULES = 0,   // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
    parameter S_COUNT = 2,                      // Number of AXI stream inputs
    parameter DATA_WIDTH = `default_DATA_WIDTH, // Width of AXI stream interfaces in bits
    parameter USER_ENABLE = 1                   // Propagate tuser signal
)
(
    axi_stream_if.axi_stream_slave_modport axi_stream_slave,
    axi_stream_if.axi_stream_master_modport axi_stream_master_0,
    axi_stream_if.axi_stream_slave_modport axi_stream_slave_0,
    axi_stream_if.axi_stream_master_modport axi_stream_master,
    input  logic [$clog2(S_COUNT)-1:0]    bypass
);

  if (REMOVE_AXIS_BYPASS_MODULES == 0) begin
    always_comb begin
      axi_stream_master_0.tdata = axi_stream_slave.tdata;
      axi_stream_master_0.tvalid = axi_stream_slave.tvalid;
      axi_stream_master_0.tlast = axi_stream_slave.tlast;
      axi_stream_master_0.tuser = axi_stream_slave.tuser;
    end 

    logic s_axis_in_tready_mux;
    always_comb begin
      if (bypass == 0) begin
        axi_stream_slave.tready = axi_stream_master_0.tready;
      end 
      else begin
        axi_stream_slave.tready = s_axis_in_tready_mux;
      end
    end 

    logic s_axis_0_tready_s;
    always_comb axi_stream_slave_0.tready = s_axis_0_tready_s; // This is needed other wise during behavioural simulation of 'correlation_non_fft' some of the signals driven by this port go to X which causes early termination of simulation with - ERROR:add_1 must be in range

    generic_axi_axis_ip_axis_mux_reg #(
      .S_COUNT(S_COUNT),                                                    // parameter S_COUNT = 4,                              // Number of AXI stream inputs
      .DATA_WIDTH(DATA_WIDTH),                                              // parameter DATA_WIDTH = 8,                           // Width of AXI stream interfaces in bits
      .KEEP_ENABLE(0),                                                      // parameter KEEP_ENABLE = (DATA_WIDTH>8),             // Propagate tkeep signal
      .USER_ENABLE(USER_ENABLE)                                             // parameter USER_ENABLE = 1,                          // Propagate tuser signal
    )
    mux_inst (
      .clk(axi_stream_slave.clk),                                           // input  wire                          clk,
      .rst(~axi_stream_slave.resetn),                                       // input  wire                          rst,
      .s_axis_tdata({axi_stream_slave.tdata, axi_stream_slave_0.tdata}),    // input  wire [S_COUNT*DATA_WIDTH-1:0] s_axis_tdata,
      .s_axis_tvalid({axi_stream_slave.tvalid, axi_stream_slave_0.tvalid}), // input  wire [S_COUNT-1:0]            s_axis_tvalid,
      .s_axis_tready({s_axis_in_tready_mux, s_axis_0_tready_s}),            // output wire [S_COUNT-1:0]            s_axis_tready,
      .s_axis_tlast({axi_stream_slave.tlast, axi_stream_slave_0.tlast}),    // input  wire [S_COUNT-1:0]            s_axis_tlast,
      .s_axis_tuser({axi_stream_slave.tuser, axi_stream_slave_0.tuser}),    // input  wire [S_COUNT*USER_WIDTH-1:0] s_axis_tuser,
      .m_axis_tdata(axi_stream_master.tdata),                               // output wire [DATA_WIDTH-1:0]         m_axis_tdata,
      .m_axis_tvalid(axi_stream_master.tvalid),                             // output wire                          m_axis_tvalid,
      .m_axis_tready(axi_stream_master.tready),                             // input  wire                          m_axis_tready,
      .m_axis_tlast(axi_stream_master.tlast),                               // output wire                          m_axis_tlast,
      .m_axis_tuser(axi_stream_master.tuser),                               // output wire [USER_WIDTH-1:0]         m_axis_tuser,
      .enable(1),                                                           // input  wire                          enable,
      .select(bypass)                                                       // input  wire [$clog2(S_COUNT)-1:0]    select
    );
  end else begin //(REMOVE_AXIS_BYPASS_MODULES != 0)
    always_comb begin
      //Module to be bypassed master AXIS port connections
      axi_stream_master_0.tdata = axi_stream_slave.tdata;
      axi_stream_master_0.tvalid = axi_stream_slave.tvalid;
      axi_stream_slave.tready = axi_stream_master_0.tready;
      axi_stream_master_0.tlast = axi_stream_slave.tlast;
      axi_stream_master_0.tuser = axi_stream_slave.tuser;
      //Module to be bypassed slave AXIS port connections
      axi_stream_master.tdata = axi_stream_slave_0.tdata;
      axi_stream_master.tvalid = axi_stream_slave_0.tvalid;
      axi_stream_slave_0.tready = axi_stream_master.tready;
      axi_stream_master.tlast = axi_stream_slave_0.tlast;
      axi_stream_master.tuser = axi_stream_slave_0.tuser;
    end    
  end

endmodule

//  // Example of how to instantiate this module
//
///**
// * @file    _axis.sv
// * @author  Steve Farmer
// * @date    07 July 2022
// * @brief   AXIStream (AXIS) processing module top level for firmware IP for Log Likelihood Ratio CRC for Nano/Enclustra platform.
// * @note    AXIStream (AXIS) processing module top level for firmware IP for Log Likelihood Ratio CRC for Nano/Enclustra platform.
// */
//
////Language: System Verilog 2009
//
//
//`timescale 1ns / 1ps
//
//`include "_ip_svh.svh"
//
//`include "axis_svh.svh"
//
////import _ip_pkg::*;
//
//module _axis #
//  (
//    parameter REMOVE_AXIS_BYPASS_MODULES = 0,         // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
//    parameter DATA_WIDTH = 64,                        // Width of AXI stream interfaces in bits
//    parameter KEEP_ENABLE = 0,                        // Propagate tkeep signal                                                                                                                                                                                                                          // (DATA_WIDTH>8),
//    parameter KEEP_WIDTH = (DATA_WIDTH/8),            // tkeep signal width (words per cycle)
//    parameter LAST_ENABLE = 1,                        // Propagate tlast signal
//    parameter ID_ENABLE = 0,                          // Propagate tid signal
//    parameter ID_WIDTH = 8,                           // tid signal width
//    parameter DEST_ENABLE = 0,                        // Propagate tdest signal
//    parameter DEST_WIDTH = 8,                         // tdest signal width
//    parameter USER_ENABLE = 1,                        // Propagate tuser signal
//    parameter USER_WIDTH = 1//,                       // tuser signal width
//  )
//  (
//    axi_stream_if.axi_stream_slave_modport _axis_slave,
//    axi_stream_if.axi_stream_master_modport _axis_master,
//    axi_reg_map_if.reg_map_slave_modport axi_register_map_slave
//  );
//
//    axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) to_module_axi_stream_if   (_axis_slave.clk, _axis_slave.resetn);
//    axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) from_module_axi_stream_if (_axis_slave.clk, _axis_slave.resetn);
//
//    axis_bypass_if #(
//      .REMOVE_AXIS_BYPASS_MODULES(REMOVE_AXIS_BYPASS_MODULES), // parameter REMOVE_AXIS_BYPASS_MODULES = 0,                    // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
//      .S_COUNT(2),                                             // parameter S_COUNT = 2,                                       // Number of AXI stream inputs
//      .DATA_WIDTH(DATA_WIDTH),                                 // parameter DATA_WIDTH = `default_DATA_WIDTH,                  // Width of AXI stream interfaces in bits
//      .USER_ENABLE(USER_ENABLE)                                // parameter USER_ENABLE = 1                                    // Propagate tuser signal
//      )
//    top_axis_bypass_inst (
//      .axi_stream_slave(_axis_slave),        // axi_stream_if.axi_stream_slave_modport axi_stream_slave,
//      .axi_stream_master_0(to_module_axi_stream_if),          // axi_stream_if.axi_stream_master_modport axi_stream_master_0,
//      .axi_stream_slave_0(from_module_axi_stream_if),         // axi_stream_if.axi_stream_slave_modport axi_stream_slave_0,
//      .axi_stream_master(_axis_master),      // axi_stream_if.axi_stream_master_modport axi_stream_master,
//      .bypass(axi_register_map_slave.bypass_everything)       // input  logic [$clog2(S_COUNT)-1:0]    bypass
//      );
//
//    axis_srl_register_reg_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH)
//    axis_srl_register_inst (
//      .axi_stream_slave(to_module_axi_stream_if),             // axi_stream_if.axi_stream_slave_modport axi_stream_slave
//      .axi_stream_master(from_module_axi_stream_if)           // axi_stream_if.axi_stream_master_modport axi_stream_master,
//    );
//
//endmodule
