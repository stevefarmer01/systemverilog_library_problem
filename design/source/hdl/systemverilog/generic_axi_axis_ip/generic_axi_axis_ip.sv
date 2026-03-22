//Language: System Verilog 2009

`timescale 1ns / 1ps

`include "generic_axi_axis_ip_svh.svh"

`include "axis_svh.svh"

//import generic_axi_axis_ip_pkg::*;

module generic_axi_axis_ip #
  (
    parameter REMOVE_AXIS_BYPASS_MODULES = 0,         // Save logic resources by removing AXIS bypass logic which is used for certain simulation tests and hardware integration
    //AXI-LITE
    parameter AXI_ADDR_WIDTH = 6,                    // width of the AXI address bus
    parameter AXI_DATA_WIDTH = 32,                    // width of the AXI data bus
    //parameter logic [31:0] BASEADDR = 32'h00000000,   // the register file's system base address
    //AXIS
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
    input  logic                   s_axis_aclk,
    input  logic                   s_axis_aresetn,
    //AXIS Slave
    input  logic [DATA_WIDTH-1:0]  s_axis_tdata,
    input  logic [KEEP_WIDTH-1:0]  s_axis_tkeep,
    input  logic                   s_axis_tvalid,
    output logic                   s_axis_tready,
    input  logic                   s_axis_tlast,
    input  logic [ID_WIDTH-1:0]    s_axis_tid,
    input  logic [DEST_WIDTH-1:0]  s_axis_tdest,
    input  logic [USER_WIDTH-1:0]  s_axis_tuser,
    //AXIS Master
    output logic [DATA_WIDTH-1:0]  m_axis_tdata,
    output logic [KEEP_WIDTH-1:0]  m_axis_tkeep,
    output logic                   m_axis_tvalid,
    input  logic                   m_axis_tready,
    output logic                   m_axis_tlast,
    output logic [ID_WIDTH-1:0]    m_axis_tid,
    output logic [DEST_WIDTH-1:0]  m_axis_tdest,
    output logic [USER_WIDTH-1:0]  m_axis_tuser,
    //AXI-LITE
    input  logic                      s_axi_aclk,
    input  logic                      s_axi_aresetn,
//    input  logic [AXI_ADDR_WIDTH-1:0] s_axi_awaddr,
//    input  logic [2:0]                s_axi_awprot,
//    input  logic                      s_axi_awvalid,
//    output logic                      s_axi_awready,
//    input  logic [31:0]               s_axi_wdata,
//    input  logic [3:0]                s_axi_wstrb,
//    input  logic                      s_axi_wvalid,
//    output logic                      s_axi_wready,
//    input  logic [AXI_ADDR_WIDTH-1:0] s_axi_araddr,
//    input  logic [2:0]                s_axi_arprot,
//    input  logic                      s_axi_arvalid,
//    output logic                      s_axi_arready,
//    output logic [31:0]               s_axi_rdata,
//    output logic [1:0]                s_axi_rresp,
//    output logic                      s_axi_rvalid,
//    input  logic                      s_axi_rready,
//    output logic [1:0]                s_axi_bresp,
//    output logic                      s_axi_bvalid,
//    input  logic                      s_axi_bready,

    input  wire [AXI_ADDR_WIDTH-1 : 0]     s_axi_awaddr_control_status,
    input  wire [2 : 0]                    s_axi_awprot_control_status,
    input  wire                            s_axi_awvalid_control_status,
    output wire                            s_axi_awready_control_status,
    input  wire [AXI_DATA_WIDTH-1 : 0]     s_axi_wdata_control_status,
    input  wire [(AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb_control_status,
    input  wire                            s_axi_wvalid_control_status,
    output wire                            s_axi_wready_control_status,
    output wire [1 : 0]                    s_axi_bresp_control_status,
    output wire                            s_axi_bvalid_control_status,
    input  wire                            s_axi_bready_control_status,
    input  wire [AXI_ADDR_WIDTH-1 : 0]     s_axi_araddr_control_status,
    input  wire [2 : 0]                    s_axi_arprot_control_status,
    input  wire                            s_axi_arvalid_control_status,
    output wire                            s_axi_arready_control_status,
    output wire [AXI_DATA_WIDTH-1 : 0]     s_axi_rdata_control_status,
    output wire [1 : 0]                    s_axi_rresp_control_status,
    output wire                            s_axi_rvalid_control_status,
    input  wire                            s_axi_rready_control_status//,
  );

  axi_reg_map_if #()
  axi_reg_map_interface (s_axi_aclk, s_axi_aresetn);

  generic_axi_axis_ip_axi_register_map 
  #(
    .C_S_AXI_DATA_WIDTH(AXI_DATA_WIDTH),             // parameter integer C_S_AXI_DATA_WIDTH   = 32,
    .C_S_AXI_ADDR_WIDTH(AXI_ADDR_WIDTH)              // parameter integer C_S_AXI_ADDR_WIDTH    = 6
  )
  axi_register_map_inst 
  (
    .axi_register_map_master(axi_reg_map_interface), // axi_reg_map_if.reg_map_master_modport     axi_register_map_master,
    .*
    //.s_axi_awaddr_control_status(),                // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr_control_status,
    //.s_axi_awprot_control_status(),                // input wire [2 : 0] s_axi_awprot_control_status,
    //.s_axi_awvalid_control_status(),               // input wire  s_axi_awvalid_control_status,
    //.s_axi_awready_control_status(),               // output wire  s_axi_awready_control_status,
    //.s_axi_wdata_control_status(),                 // input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata_control_status,
    //.s_axi_wstrb_control_status(),                 // input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb_control_status,
    //.s_axi_wvalid_control_status(),                // input wire  s_axi_wvalid_control_status,
    //.s_axi_wready_control_status(),                // output wire  s_axi_wready_control_status,
    //.s_axi_bresp_control_status(),                 // output wire [1 : 0] s_axi_bresp_control_status,
    //.s_axi_bvalid_control_status(),                // output wire  s_axi_bvalid_control_status,
    //.s_axi_bready_control_status(),                // input wire  s_axi_bready_control_status,
    //.s_axi_araddr_control_status(),                // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr_control_status,
    //.s_axi_arprot_control_status(),                // input wire [2 : 0] s_axi_arprot_control_status,
    //.s_axi_arvalid_control_status(),               // input wire  s_axi_arvalid_control_status,
    //.s_axi_arready_control_status(),               // output wire  s_axi_arready_control_status,
    //.s_axi_rdata_control_status(),                 // output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata_control_status,
    //.s_axi_rresp_control_status(),                 // output wire [1 : 0] s_axi_rresp_control_status,
    //.s_axi_rvalid_control_status(),                // output wire  s_axi_rvalid_control_status,
    //.s_axi_rready_control_status()                 // input wire  s_axi_rready_control_status,
  );

  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  to_llr_axis_axi_stream_if   (s_axis_aclk, s_axis_aresetn);
  axi_stream_if #(DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH) 
  from_llr_axis_axi_stream_if (s_axis_aclk, s_axis_aresetn);

  //Convert AXIStream BFM ports to interfaces for connecting to top level ports
  always_comb begin
    //DUT slave port
    to_llr_axis_axi_stream_if.tdata = s_axis_tdata;
    to_llr_axis_axi_stream_if.tvalid = s_axis_tvalid;
    s_axis_tready = to_llr_axis_axi_stream_if.tready;
    to_llr_axis_axi_stream_if.tlast = s_axis_tlast;
    to_llr_axis_axi_stream_if.tuser = s_axis_tuser;
    //DUT master port
    m_axis_tdata = from_llr_axis_axi_stream_if.tdata;
    m_axis_tvalid = from_llr_axis_axi_stream_if.tvalid;
    from_llr_axis_axi_stream_if.tready = m_axis_tready;
    m_axis_tlast = from_llr_axis_axi_stream_if.tlast;
    m_axis_tuser = from_llr_axis_axi_stream_if.tuser;
  end

  axi_reg_map_if #()
  axi_reg_map_interface_domain_axis (s_axis_aclk, s_axi_aresetn);
  axi_reg_map_if #()
  axi_reg_map_interface_domain_top (s_axis_aclk, s_axi_aresetn);

  domain_cross_from_axi_reg_map_interface
  #(
    .NUMBER_OF_REGS(2)                                                // parameter NUMBER_OF_REGS = 2
  )
  domain_cross_from_axi_reg_map_interface_inst 
  (
    .axi_register_map_slave(axi_reg_map_interface),                   // axi_reg_map_if.reg_map_slave_modport  axi_register_map_slave,
    .axi_register_map_axis_master(axi_reg_map_interface_domain_axis), // axi_reg_map_if.reg_map_master_modport axi_register_map_axis_master
    .axi_register_map_top_master(axi_reg_map_interface_domain_top)    // axi_reg_map_if.reg_map_master_modport axi_register_map_top_master
  );

  //AXIS processing module
  generic_axi_axis_ip_axis #(REMOVE_AXIS_BYPASS_MODULES, DATA_WIDTH, KEEP_ENABLE, KEEP_WIDTH, LAST_ENABLE, ID_ENABLE, ID_WIDTH, DEST_ENABLE, DEST_WIDTH, USER_ENABLE, USER_WIDTH)
  axis_inst 
  (
    .generic_axi_axis_ip_axis_slave(to_llr_axis_axi_stream_if),    // axi_stream_if.axi_stream_slave_modport generic_axi_axis_ip_axis_slave
    .generic_axi_axis_ip_axis_master(from_llr_axis_axi_stream_if), // axi_stream_if.axi_stream_master_modport generic_axi_axis_ip_axis_master,
    .axi_register_map_slave(axi_reg_map_interface_domain_axis)   // axi_reg_map_if.reg_map_slave_modport axi_register_map_slave,
  );

  //Top level interface to AXI register map
  always_comb begin : SHOW_VIA_AXI_THIS_IP_IS_PRESENT
    axi_reg_map_interface_domain_top.status_present = '1; // Show via AXI register map that this IP is present by setting this constant
  end : SHOW_VIA_AXI_THIS_IP_IS_PRESENT

endmodule

