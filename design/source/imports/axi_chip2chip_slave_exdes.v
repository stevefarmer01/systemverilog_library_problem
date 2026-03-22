 
/******************************************************************************
-- (c) Copyright 1995 - 2010 Xilinx, Inc. All rights reserved.
--
-- This file contains confidential and proprietary information
-- of Xilinx, Inc. and is protected under U.S. and
-- international copyright and other intellectual property
-- laws.
--
-- DISCLAIMER
-- This disclaimer is not a license and does not grant any
-- rights to the materials distributed herewith. Except as
-- otherwise provided in a valid license issued to you by
-- Xilinx, and to the maximum extent permitted by applicable
-- law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
-- WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
-- AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
-- BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
-- INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
-- (2) Xilinx shall not be liable (whether in contract or tort,
-- including negligence, or under any other theory of
-- liability) for any loss or damage of any kind or nature
-- related to, arising under or in connection with these
-- materials, including for any direct, or any indirect,
-- special, incidental, or consequential loss or damage
-- (including loss of data, profits, goodwill, or any type of
-- loss or damage suffered as a result of any action brought
-- by a third party) even if such damage or loss was
-- reasonably foreseeable or Xilinx had been advised of the
-- possibility of the same.
--
-- CRITICAL APPLICATIONS
-- Xilinx products are not designed or intended to be fail-
-- safe, or for use in any application requiring fail-safe
-- performance, such as life-support or safety devices or
-- systems, Class III medical devices, nuclear facilities,
-- applications related to the deployment of airbags, or any
-- other applications that could lead to death, personal
-- injury, or severe property or environmental damage
-- (individually and collectively, "Critical
-- Applications"). Customer assumes the sole risk and
-- liability of any use of Xilinx products in Critical
-- Applications, subject only to applicable laws and
-- regulations governing limitations on product liability.
--
-- THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
-- PART OF THIS FILE AT ALL TIMES.
*******************************************************************************/
`timescale 1ns/1ps
(* DowngradeIPIdentifiedWarnings="yes" *)
module axi_chip2chip_slave_exdes #(
    parameter USE_CUSTOM_REG_MAP = 0,
    parameter USE_SIMULATE_VERSION_OF_IP = 0
)
(
   input  wire        clk_200_p,
   input  wire        clk_200_n,
   input  wire        reset,
   input  wire        start_traffic,

    output wire                  t_axi_calib_done_out_slv,
    output wire                  t_axi_calib_error_out_slv,
    input   wire                  GTXQ1_P,
    input   wire                  GTXQ1_N,
    input   wire                  PMA_INIT,
    input   wire                  INIT_CLK_P,
    input   wire                  INIT_CLK_N,
    output  wire                  t_axi_phy_error_out_slv,
    input   wire                  aurora_rx_p_slv,
    input   wire                  aurora_rx_n_slv,
    output  wire                  aurora_tx_p_slv, 
    output  wire                  aurora_tx_n_slv,
    output wire                   axi4_error
);

 (* mark_debug = "true" *)   wire     aw_error;
 (* mark_debug = "true" *)   wire     ar_error;
 (* mark_debug = "true" *)   wire     w_error;
 (* mark_debug = "true" *)   wire     r_error;
 (* mark_debug = "true" *)   wire     b_error;
    wire     clk_out_100;  
 (* mark_debug = "true" *)   wire     clk_locked;

   assign axi4_error = aw_error | ar_error | w_error | r_error | b_error;

    wire                  t_axi_phy_clk_mas;
    wire                  t_axi_phy_clk_slv;
 (* mark_debug = "true" *)   wire                  t_axi_auro_channel_up_mas;
 (* mark_debug = "true" *)   wire                  t_axi_auro_channel_up_slv;
 (* mark_debug = "true" *)   wire                  t_axi_auro_tx_tvalid_mas;
 (* mark_debug = "true" *)   wire                  t_axi_auro_tx_tvalid_slv;
 (* mark_debug = "true" *)   wire                  t_axi_auro_tx_tready_mas;
 (* mark_debug = "true" *)   wire                  t_axi_auro_tx_tready_slv;
 (* mark_debug = "true" *)   wire                  t_axi_auro_rx_tvalid_mas;
 (* mark_debug = "true" *)   wire                  t_axi_auro_rx_tvalid_slv;
 (* mark_debug = "true" *)   wire [64-1:0]         t_axi_auro_tx_tdata_mas;
 (* mark_debug = "true" *)   wire [64-1:0]         t_axi_auro_tx_tdata_slv;
 (* mark_debug = "true" *)   wire [64-1:0]         t_axi_auro_rx_tdata_mas;
 (* mark_debug = "true" *)   wire [64-1:0]         t_axi_auro_rx_tdata_slv;
 (* mark_debug = "true" *)   wire                   do_cc_mas;
 (* mark_debug = "true" *)   wire                   do_cc_slv;
 (* mark_debug = "true" *)   wire                   INIT_clk_mas;
 (* mark_debug = "true" *)   wire                   INIT_clk_slv;
 (* mark_debug = "true" *)   wire                   PMA_INIT_OUT;
 (* mark_debug = "true" *)   wire                   aurora_mmcm_not_locked_mas;
 (* mark_debug = "true" *)   wire                   aurora_mmcm_not_locked_slv;
 (* mark_debug = "true" *)   wire                   aurora_rst_out_mas;
 (* mark_debug = "true" *)   wire                   aurora_rst_out_slv;
    wire [4-1:0]          axi_c2c_m2s_intr_in;
    wire [4-1:0]          axi_c2c_s2m_intr_out;
    wire [4-1:0]          axi_c2c_s2m_intr_in;
    wire [4-1:0]          axi_c2c_m2s_intr_out;
    

    wire                  m_axi_aclk;
 (* mark_debug = "true" *)   wire                  m_axi_reset_n;
 (* mark_debug = "true" *)   wire [32-1:0]         m_axi_awaddr;
 (* mark_debug = "true" *)   wire [8-1:0]          m_axi_awlen;
 (* mark_debug = "true" *)   wire [3-1:0]          m_axi_awsize;
 (* mark_debug = "true" *)   wire [2-1:0]          m_axi_awburst;
 (* mark_debug = "true" *)   wire                  m_axi_awvalid;
 (* mark_debug = "true" *)   wire                  m_axi_awready;
 (* mark_debug = "true" *)   wire [6-1:0]          m_axi_awid;
 (* mark_debug = "true" *)   wire [4-1:0]          m_axi_wstrb;
 (* mark_debug = "true" *)   wire                  m_axi_wlast;
 (* mark_debug = "true" *)   wire                  m_axi_wvalid;
 (* mark_debug = "true" *)   wire                  m_axi_wready;
 (* mark_debug = "true" *)   wire [4-1:0]          m_axi_wuser;
 (* mark_debug = "true" *)   wire [32-1:0]         m_axi_wdata;
 (* mark_debug = "true" *)   wire [2-1:0]          m_axi_bresp;
 (* mark_debug = "true" *)   wire                  m_axi_bvalid;
 (* mark_debug = "true" *)   wire                  m_axi_bready;
 (* mark_debug = "true" *)   wire [6-1:0]          m_axi_bid;
 (* mark_debug = "true" *)   wire [32-1:0]         m_axi_araddr;
 (* mark_debug = "true" *)   wire [8-1:0]          m_axi_arlen;
 (* mark_debug = "true" *)   wire [3-1:0]          m_axi_arsize;
 (* mark_debug = "true" *)   wire [2-1:0]          m_axi_arburst;
 (* mark_debug = "true" *)   wire                  m_axi_arvalid;
 (* mark_debug = "true" *)   wire                  m_axi_arready;
 (* mark_debug = "true" *)   wire [6-1:0]          m_axi_arid;
 (* mark_debug = "true" *)   wire [2-1:0]          m_axi_rresp;
 (* mark_debug = "true" *)   wire                  m_axi_rlast;
 (* mark_debug = "true" *)   wire                  m_axi_rvalid;
 (* mark_debug = "true" *)   wire                  m_axi_rready;
 (* mark_debug = "true" *)   wire [6-1:0]          m_axi_rid;
 (* mark_debug = "true" *)   wire [32-1:0]         m_axi_rdata;

 (* mark_debug = "true" *)   wire                  axi_lite_reset_n; 

  //--------------------------------------------------------
  // reset connections 
  //--------------------------------------------------------
 (* mark_debug = "true" *) reg [3:0] axi_aresetn_sync;

 wire traffic_gen_chk_reset_c;
  reg traffic_gen_chk_reset_r;
  reg traffic_gen_chk_reset_lite_r;
  assign traffic_gen_chk_reset_c =  (~( (~start_traffic) | reset) );



  always@(posedge clk_out_100 ) begin
     traffic_gen_chk_reset_r <= traffic_gen_chk_reset_c;
  end



  always@(posedge clk_out_100 ) begin
     traffic_gen_chk_reset_lite_r <= traffic_gen_chk_reset_c;
  end









  always@(posedge clk_out_100 or posedge reset) begin
    if(reset) begin
      axi_aresetn_sync <= 4'b1111;
    end else begin
      axi_aresetn_sync <= {axi_aresetn_sync[2:0],1'b0};
    end
  end

  assign s_axi_reset_n = ~axi_aresetn_sync[3];
  assign m_axi_reset_n = ~axi_aresetn_sync[3];
  assign axi_lite_reset_n = ~axi_aresetn_sync[3];
  


  //--------------------------------------------------------
  // interrupt connections 
  //--------------------------------------------------------
  reg [9:0] intr_counter;

  always@(posedge clk_out_100 or posedge reset) begin
    if(reset) begin
      intr_counter <= 10'b 0;
    end else begin
      intr_counter <= intr_counter + 1'b1;
    end
  end

  assign axi_c2c_m2s_intr_in[3:1] = 3'b 0;
  assign axi_c2c_s2m_intr_in[3:1] = 3'b 0;
  assign axi_c2c_m2s_intr_in[0]   = intr_counter[9];
  assign axi_c2c_s2m_intr_in[0]   = intr_counter[9];


clk_wiz_0 clk_wiz_inst (
     .clk_in1_n                       (clk_200_n),
     .clk_in1_p                       (clk_200_p),
     .clk_out1                        (clk_out_100),
     .clk_out2                        (),
     .locked                          (clk_locked),
     .reset                           (reset)
);
axi_chip2chip_slave_dut #(
    .USE_SIMULATE_VERSION_OF_IP(USE_SIMULATE_VERSION_OF_IP) // parameter USE_SIMULATE_VERSION_OF_IP = 0
  ) 
  dut_inst 
  (
     .m_aclk                           ( clk_out_100 ),
     .m_aresetn                        ( m_axi_reset_n ),
     .m_axi_awid                       ( m_axi_awid    ),
     .m_axi_awaddr                     ( m_axi_awaddr  ),
     .m_axi_awlen                      ( m_axi_awlen   ),
     .m_axi_awsize                     ( m_axi_awsize  ),
     .m_axi_awburst                    ( m_axi_awburst ),
     .m_axi_awvalid                    ( m_axi_awvalid ),
     .m_axi_awready                    ( m_axi_awready ),
     .m_axi_wuser                      ( m_axi_wuser   ), //From UG761 - WUSER Generally, not implemented in Xilinx endpoint IP. Infrastructure IP will pass USER bits across a system
     .m_axi_wdata                      ( m_axi_wdata   ),
     .m_axi_wstrb                      ( m_axi_wstrb   ),
     .m_axi_wlast                      ( m_axi_wlast   ),
     .m_axi_wvalid                     ( m_axi_wvalid  ),
     .m_axi_wready                     ( m_axi_wready  ),
     .m_axi_bid                        ( m_axi_bid     ),
     .m_axi_bresp                      ( m_axi_bresp   ),
     .m_axi_bvalid                     ( m_axi_bvalid  ),
     .m_axi_bready                     ( m_axi_bready  ),
     .m_axi_arid                       ( m_axi_arid    ),
     .m_axi_araddr                     ( m_axi_araddr  ),
     .m_axi_arlen                      ( m_axi_arlen   ),
     .m_axi_arsize                     ( m_axi_arsize  ),
     .m_axi_arburst                    ( m_axi_arburst ),
     .m_axi_arvalid                    ( m_axi_arvalid ),
     .m_axi_arready                    ( m_axi_arready ),
     .m_axi_rid                        ( m_axi_rid     ),
     .m_axi_rdata                      ( m_axi_rdata   ),
     .m_axi_rresp                      ( m_axi_rresp   ),
     .m_axi_rlast                      ( m_axi_rlast   ),
     .m_axi_rvalid                     ( m_axi_rvalid  ),
     .m_axi_rready                     ( m_axi_rready  ),
     .axi_c2c_phy_clk_slv              ( t_axi_phy_clk_slv ),
     .t_axi_auro_channel_up_slv        ( t_axi_auro_channel_up_slv ),
     .t_axi_auro_tx_tready_slv         ( t_axi_auro_tx_tready_slv  ),
     .t_axi_auro_tx_tdata_slv          ( t_axi_auro_tx_tdata_slv   ),
     .t_axi_auro_tx_tvalid_slv         ( t_axi_auro_tx_tvalid_slv  ),
     .t_axi_auro_rx_tdata_slv          ( t_axi_auro_rx_tdata_slv   ),
     .t_axi_auro_rx_tvalid_slv         ( t_axi_auro_rx_tvalid_slv  ),
     .do_cc_slv                        ( do_cc_slv                 ),
     .INIT_clk_slv                     ( INIT_clk_slv              ),
     .pma_init_in_slv                  ( PMA_INIT                  ),
     .pma_init_out_slv                 ( PMA_INIT_OUT              ),  
     .aurora_mmcm_not_locked_slv       ( aurora_mmcm_not_locked_slv),
     .aurora_rst_out_slv               ( aurora_rst_out_slv        ),  
     .t_axi_phy_error_out_slv          ( t_axi_phy_error_out_slv   ),

     .t_axi_calib_done_out_slv         ( t_axi_calib_done_out_slv  ),
     .t_axi_calib_error_out_slv        ( t_axi_calib_error_out_slv ),
     .axi_c2c_s2m_intr_in              ( axi_c2c_s2m_intr_in  ),
     .axi_c2c_m2s_intr_out             ( axi_c2c_m2s_intr_out )
);

//For AXI register map either use a RAM with 16 bit address bus for chip2cip testing or a custom register map like a real FPGA product
generate
  if (USE_CUSTOM_REG_MAP == 0) begin : IF_USE_CUSTOM_REG_MAP_EQUALS_0
    axi_dut #
    (
        //// Width of data bus in bits
        //parameter DATA_WIDTH = 32,
        //// Width of address bus in bits
        //parameter ADDR_WIDTH = 16,
        //// Width of wstrb (width of data bus in words)
        //parameter STRB_WIDTH = (DATA_WIDTH/8),
        //// Width of ID signal
        //parameter ID_WIDTH = 8,
        //// Extra pipeline register on output
        //parameter PIPELINE_OUTPUT = 0,
        //parameter bit INDUCE_ERROR = '0
    )
    axi_dut_reg_map_inst_0
    (
        .clk(clk_out_100),             // input  wire                   clk,
        .rst(~m_axi_reset_n),          // input  wire                   rst, //WARNING THIS IS NOT A NEGATED RESET UNLIKE THE USUAL axi_reset_n IN AXI
        .s_axi_awid(m_axi_awid),       // input  wire [ID_WIDTH-1:0]    s_axi_awid,
        .s_axi_awaddr(m_axi_awaddr),   // input  wire [ADDR_WIDTH-1:0]  s_axi_awaddr,
        .s_axi_awlen(m_axi_awlen),     // input  wire [7:0]             s_axi_awlen,
        .s_axi_awsize(m_axi_awsize),   // input  wire [2:0]             s_axi_awsize,
        .s_axi_awburst(m_axi_awburst), // input  wire [1:0]             s_axi_awburst,
        .s_axi_awlock(1'b0),           // input  wire                   //s_axi_awlock,  //From UG761 - AWLOCK Exclusive access support not implemented in endpoint Xilinx IP. Infrastructure IP will pass exclusive access bit across a system.
        .s_axi_awcache(4'b0000),       // input  wire [3:0]             //s_axi_awcache, //From UG761 - AWCACHE 0011 value recommended.
        .s_axi_awprot(3'b000),         // input  wire [2:0]             //s_axi_awprot,  //From UG761 - AWPROT 000 value recommended
        .s_axi_awvalid(m_axi_awvalid), // input  wire                   s_axi_awvalid,
        .s_axi_awready(m_axi_awready), // output wire                   s_axi_awready,
        .s_axi_wdata(m_axi_wdata),     // input  wire [DATA_WIDTH-1:0]  s_axi_wdata,
        .s_axi_wstrb(m_axi_wstrb),     // input  wire [STRB_WIDTH-1:0]  s_axi_wstrb,
        .s_axi_wlast(m_axi_wlast),     // input  wire                   s_axi_wlast,
        .s_axi_wvalid(m_axi_wvalid),   // input  wire                   s_axi_wvalid,
        .s_axi_wready(m_axi_wready),   // output wire                   s_axi_wready,
        .s_axi_bid(m_axi_bid),         // output wire [ID_WIDTH-1:0]    s_axi_bid,
        .s_axi_bresp(m_axi_bresp),     // output wire [1:0]             s_axi_bresp,
        .s_axi_bvalid(m_axi_bvalid),   // output wire                   s_axi_bvalid,
        .s_axi_bready(m_axi_bready),   // input  wire                   s_axi_bready,
        .s_axi_arid(m_axi_arid),       // input  wire [ID_WIDTH-1:0]    s_axi_arid,
        .s_axi_araddr(m_axi_araddr),   // input  wire [ADDR_WIDTH-1:0]  s_axi_araddr,
        .s_axi_arlen(m_axi_arlen),     // input  wire [7:0]             s_axi_arlen,
        .s_axi_arsize(m_axi_arsize),   // input  wire [2:0]             s_axi_arsize,
        .s_axi_arburst(m_axi_arburst), // input  wire [1:0]             s_axi_arburst,
        .s_axi_arlock(1'b0),           // input  wire                   //s_axi_arlock,  //From UG761 - AWLOCK Exclusive access support not implemented in endpoint Xilinx IP. Infrastructure IP will pass exclusive access bit across a system.
        .s_axi_arcache(4'b0000),       // input  wire [3:0]             //s_axi_arcache, //From UG761 - AWCACHE 0011 value recommended. However, in successful testbench runs this is set to 0000
        .s_axi_arprot(3'b000),         // input  wire [2:0]             //s_axi_arprot,  //From UG761 - AWPROT 000 value recommended
        .s_axi_arvalid(m_axi_arvalid), // input  wire                   s_axi_arvalid,
        .s_axi_arready(m_axi_arready), // output wire                   s_axi_arready,
        .s_axi_rid(m_axi_rid),         // output wire [ID_WIDTH-1:0]    s_axi_rid,
        .s_axi_rdata(m_axi_rdata),     // output wire [DATA_WIDTH-1:0]  s_axi_rdata,
        .s_axi_rresp(m_axi_rresp),     // output wire [1:0]             s_axi_rresp,
        .s_axi_rlast(m_axi_rlast),     // output wire                   s_axi_rlast,
        .s_axi_rvalid(m_axi_rvalid),   // output wire                   s_axi_rvalid,
        .s_axi_rready(m_axi_rready)    // input  wire                   s_axi_rready
    );
  end : IF_USE_CUSTOM_REG_MAP_EQUALS_0
  else begin : IF_USE_CUSTOM_REG_MAP_EQUALS_1

    localparam integer LOCALPARAM_AXI_DATA_WIDTH   = 32;    
    localparam integer LOCALPARAM_AXI_ADDR_WIDTH   = 6;   
    wire [LOCALPARAM_AXI_ADDR_WIDTH-1:0]     s_axi_awaddr_control_status;
    wire [2:0]                        s_axi_awprot_control_status;
    wire                              s_axi_awvalid_control_status;
    wire                              s_axi_awready_control_status;
    wire [LOCALPARAM_AXI_DATA_WIDTH-1:0]     s_axi_wdata_control_status;
    wire [(LOCALPARAM_AXI_DATA_WIDTH/8)-1:0] s_axi_wstrb_control_status;
    wire                              s_axi_wvalid_control_status;
    wire                              s_axi_wready_control_status;
    wire [1:0]                        s_axi_bresp_control_status;
    wire                              s_axi_bvalid_control_status;
    wire                              s_axi_bready_control_status;
    wire [LOCALPARAM_AXI_ADDR_WIDTH-1:0]     s_axi_araddr_control_status;
    wire [2:0]                        s_axi_arprot_control_status;
    wire                              s_axi_arvalid_control_status;
    wire                              s_axi_arready_control_status;
    wire [LOCALPARAM_AXI_DATA_WIDTH-1:0]     s_axi_rdata_control_status;
    wire [1:0]                        s_axi_rresp_control_status;
    wire                              s_axi_rvalid_control_status;
    wire                              s_axi_rready_control_status;

    axi_converter_axi4_to_axi4_lite axi_converter_axi4_to_axi4_lite_inst_0 (
      .aclk(clk_out_100),                           // input wire aclk
      .aresetn(m_axi_reset_n),                      // input wire aresetn
      .s_axi_awid(m_axi_awid),                      // input wire [5 : 0] s_axi_awid
      .s_axi_awaddr(m_axi_awaddr),                  // input wire [31 : 0] s_axi_awaddr
      .s_axi_awlen(m_axi_awlen),                    // input wire [7 : 0] s_axi_awlen
      .s_axi_awsize(m_axi_awsize),                  // input wire [2 : 0] s_axi_awsize
      .s_axi_awburst(m_axi_awburst),                // input wire [1 : 0] s_axi_awburst
      .s_axi_awlock(1'b0),                          // input wire [0 : 0] s_axi_awlock //From UG761 - AWLOCK Exclusive access support not implemented in endpoint Xilinx IP. Infrastructure IP will pass exclusive access bit across a system.
      .s_axi_awcache(4'b0000),                      // input wire [3 : 0] s_axi_awcache //From UG761 - AWCACHE 0011 value recommended. However, in successful testbench runs this is set to 0000
      .s_axi_awprot(3'b000),                        // input wire [2 : 0] s_axi_awprot //From UG761 - AWPROT 000 value recommended
      .s_axi_awregion(4'b0000),                     // input wire [3 : 0] s_axi_awregion //From IHI0022C_amba_axi_v2_0_protocol_spec.pdf - default value 0x0
      .s_axi_awqos(4'b0000),                        // input wire [3 : 0] s_axi_awqos //From IHI0022C_amba_axi_v2_0_protocol_spec.pdf - default value 0x0
      .s_axi_awvalid(m_axi_awvalid),                // input wire s_axi_awvalid
      .s_axi_awready(m_axi_awready),                // output wire s_axi_awready
      .s_axi_wdata(m_axi_wdata),                    // input wire [31 : 0] s_axi_wdata
      .s_axi_wstrb(m_axi_wstrb),                    // input wire [3 : 0] s_axi_wstrb
      .s_axi_wlast(m_axi_wlast),                    // input wire s_axi_wlast
      .s_axi_wvalid(m_axi_wvalid),                  // input wire s_axi_wvalid
      .s_axi_wready(m_axi_wready),                  // output wire s_axi_wready
      .s_axi_bid(m_axi_bid),                        // output wire [5 : 0] s_axi_bid
      .s_axi_bresp(m_axi_bresp),                    // output wire [1 : 0] s_axi_bresp
      .s_axi_bvalid(m_axi_bvalid),                  // output wire s_axi_bvalid
      .s_axi_bready(m_axi_bready),                  // input wire s_axi_bready
      .s_axi_arid(m_axi_arid),                      // input wire [5 : 0] s_axi_arid
      .s_axi_araddr(m_axi_araddr),                  // input wire [31 : 0] s_axi_araddr
      .s_axi_arlen(m_axi_arlen),                    // input wire [7 : 0] s_axi_arlen
      .s_axi_arsize(m_axi_arsize),                  // input wire [2 : 0] s_axi_arsize
      .s_axi_arburst(m_axi_arburst),                // input wire [1 : 0] s_axi_arburst
      .s_axi_arlock(1'b0),                          // input wire [0 : 0] s_axi_arlock //From UG761 - AWLOCK Exclusive access support not implemented in endpoint Xilinx IP. Infrastructure IP will pass exclusive access bit across a system.
      .s_axi_arcache(4'b0000),                      // input wire [3 : 0] s_axi_arcache //From UG761 - AWCACHE 0011 value recommended. However, in successful testbench runs this is set to 0000
      .s_axi_arprot(3'b000),                        // input wire [2 : 0] s_axi_arprot //From UG761 - AWPROT 000 value recommended
      .s_axi_arregion(4'b0000),                     // input wire [3 : 0] s_axi_arregion //From IHI0022C_amba_axi_v2_0_protocol_spec.pdf - default value 0x0
      .s_axi_arqos(4'b0000),                        // input wire [3 : 0] s_axi_arqos //From IHI0022C_amba_axi_v2_0_protocol_spec.pdf - default value 0x0
      .s_axi_arvalid(m_axi_arvalid),                // input wire s_axi_arvalid
      .s_axi_arready(m_axi_arready),                // output wire s_axi_arready
      .s_axi_rid(m_axi_rid),                        // output wire [5 : 0] s_axi_rid
      .s_axi_rdata(m_axi_rdata),                    // output wire [31 : 0] s_axi_rdata
      .s_axi_rresp(m_axi_rresp),                    // output wire [1 : 0] s_axi_rresp
      .s_axi_rlast(m_axi_rlast),                    // output wire s_axi_rlast
      .s_axi_rvalid(m_axi_rvalid),                  // output wire s_axi_rvalid
      .s_axi_rready(m_axi_rready),                  // input wire s_axi_rready
      .m_axi_awaddr(s_axi_awaddr_control_status),   // output wire [31 : 0] m_axi_awaddr
      .m_axi_awprot(s_axi_awprot_control_status),   // output wire [2 : 0] m_axi_awprot
      .m_axi_awvalid(s_axi_awvalid_control_status), // output wire m_axi_awvalid
      .m_axi_awready(s_axi_awready_control_status), // input wire m_axi_awready
      .m_axi_wdata(s_axi_wdata_control_status),     // output wire [31 : 0] m_axi_wdata
      .m_axi_wstrb(s_axi_wstrb_control_status),     // output wire [3 : 0] m_axi_wstrb
      .m_axi_wvalid(s_axi_wvalid_control_status),   // output wire m_axi_wvalid
      .m_axi_wready(s_axi_wready_control_status),   // input wire m_axi_wready
      .m_axi_bresp(s_axi_bresp_control_status),     // input wire [1 : 0] m_axi_bresp
      .m_axi_bvalid(s_axi_bvalid_control_status),   // input wire m_axi_bvalid
      .m_axi_bready(s_axi_bready_control_status),   // output wire m_axi_bready
      .m_axi_araddr(s_axi_araddr_control_status),   // output wire [31 : 0] m_axi_araddr
      .m_axi_arprot(s_axi_arprot_control_status),   // output wire [2 : 0] m_axi_arprot
      .m_axi_arvalid(s_axi_arvalid_control_status), // output wire m_axi_arvalid
      .m_axi_arready(s_axi_arready_control_status), // input wire m_axi_arready
      .m_axi_rdata(s_axi_rdata_control_status),     // input wire [31 : 0] m_axi_rdata
      .m_axi_rresp(s_axi_rresp_control_status),     // input wire [1 : 0] m_axi_rresp
      .m_axi_rvalid(s_axi_rvalid_control_status),   // input wire m_axi_rvalid
      .m_axi_rready(s_axi_rready_control_status)    // output wire m_axi_rready
    );
    // INST_TAG_END ------ End INSTANTIATION Template ---------
    axi_chip2chip_slave_axi_register_map 
    #(
      .C_S_AXI_DATA_WIDTH(LOCALPARAM_AXI_DATA_WIDTH),             // parameter integer C_S_AXI_DATA_WIDTH   = 32,
      .C_S_AXI_ADDR_WIDTH(LOCALPARAM_AXI_ADDR_WIDTH)              // parameter integer C_S_AXI_ADDR_WIDTH    = 6
    )
    axi_register_map_inst 
    (
      //.axi_register_map_master(axi_reg_map_interface),           // axi_reg_map_if.reg_map_master_modport     axi_register_map_master,
      //.*
      .s_axi_aclk_control_status(clk_out_100),                     // input wire s_axi_aclk_control_status,
      .s_axi_aresetn_control_status(m_axi_reset_n),                // input wire s_axi_aresetn_control_status,
      .s_axi_awaddr_control_status(s_axi_awaddr_control_status),   // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_awaddr_control_status,
      .s_axi_awprot_control_status(s_axi_awprot_control_status),   // input wire [2 : 0] s_axi_awprot_control_status,
      .s_axi_awvalid_control_status(s_axi_awvalid_control_status), // input wire  s_axi_awvalid_control_status,
      .s_axi_awready_control_status(s_axi_awready_control_status), // output wire  s_axi_awready_control_status,
      .s_axi_wdata_control_status(s_axi_wdata_control_status),     // input wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_wdata_control_status,
      .s_axi_wstrb_control_status(s_axi_wstrb_control_status),     // input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb_control_status,
      .s_axi_wvalid_control_status(s_axi_wvalid_control_status),   // input wire  s_axi_wvalid_control_status,
      .s_axi_wready_control_status(s_axi_wready_control_status),   // output wire  s_axi_wready_control_status,
      .s_axi_bresp_control_status(s_axi_bresp_control_status),     // output wire [1 : 0] s_axi_bresp_control_status,
      .s_axi_bvalid_control_status(s_axi_bvalid_control_status),   // output wire  s_axi_bvalid_control_status,
      .s_axi_bready_control_status(s_axi_bready_control_status),   // input wire  s_axi_bready_control_status,
      .s_axi_araddr_control_status(s_axi_araddr_control_status),   // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] s_axi_araddr_control_status,
      .s_axi_arprot_control_status(s_axi_arprot_control_status),   // input wire [2 : 0] s_axi_arprot_control_status,
      .s_axi_arvalid_control_status(s_axi_arvalid_control_status), // input wire  s_axi_arvalid_control_status,
      .s_axi_arready_control_status(s_axi_arready_control_status), // output wire  s_axi_arready_control_status,
      .s_axi_rdata_control_status(s_axi_rdata_control_status),     // output wire [C_S_AXI_DATA_WIDTH-1 : 0] s_axi_rdata_control_status,
      .s_axi_rresp_control_status(s_axi_rresp_control_status),     // output wire [1 : 0] s_axi_rresp_control_status,
      .s_axi_rvalid_control_status(s_axi_rvalid_control_status),   // output wire  s_axi_rvalid_control_status,
      .s_axi_rready_control_status(s_axi_rready_control_status)    // input wire  s_axi_rready_control_status,
    );
  end : IF_USE_CUSTOM_REG_MAP_EQUALS_1
endgenerate


//traffic_gen
//#(
//  .C_GEN_MAS_TRAFFIC      (0),
//  .C_GEN_TRAFFIC_MAS_SLV  (0), 
//  .C_AXI_DATA_WIDTH       ( 32 ),
//  .C_AXI_ID_WIDTH         ( 6 ),
//  .C_AXI_ADDR_WIDTH       ( 32 ),
//  .C_AXI_LEN_WIDTH        ( 8  ),
//  .C_AXI_BRST_WIDTH       ( 2  ),
//  .C_AXI_STB_WIDTH        ( 4 ),
//  .C_AXI_SIZE_WIDTH       ( 3  ),
//  .C_AXI_RESP_WIDTH       ( 2  ),
//  .C_AXI_WUSER_WIDTH      ( 4 )
//)
//traffic_gen_inst 
//(
//  .s_axi_aclk        ( clk_out_100   ),
//  .s_axi_reset_n     ( traffic_gen_chk_reset_r ),
//  .m_axi_aclk        ( clk_out_100   ),
//  .m_axi_reset_n     ( traffic_gen_chk_reset_r ),
//  .m_axi_wvalid      ( m_axi_wvalid  ),
//  .m_axi_arvalid     ( m_axi_arvalid ),
//  .m_axi_awvalid     ( m_axi_awvalid ),
//  .m_axi_arready     ( m_axi_arready ),
//  .m_axi_awready     ( m_axi_awready ),
//  .m_axi_wready      ( m_axi_wready  ),
//  .m_axi_rlast       ( m_axi_rlast   ),
//  .m_axi_rvalid      ( m_axi_rvalid  ),
//  .m_axi_rdata       ( m_axi_rdata   ),
//  .m_axi_rid         ( m_axi_rid     ),
//  .m_axi_rresp       ( m_axi_rresp   ),
//  .m_axi_rready      ( m_axi_rready  ),
//  .m_axi_bvalid      ( m_axi_bvalid  ),
//  .m_axi_bid         ( m_axi_bid     ),
//  .m_axi_bresp       ( m_axi_bresp   ),
//  .m_axi_bready      ( m_axi_bready  ),
//  .s_axi_awvalid     ( ),
//  .s_axi_awaddr      ( ),
//  .s_axi_awburst     ( ),
//  .s_axi_awid        ( ),
//  .s_axi_awlen       ( ),
//  .s_axi_awsize      ( ),
//  .s_axi_awready     ( 1'b 0 ),
//  .s_axi_araddr      ( ),
//  .s_axi_arvalid     ( ),
//  .s_axi_arburst     ( ),
//  .s_axi_arid        ( ),
//  .s_axi_arlen       ( ),
//  .s_axi_arsize      ( ),
//  .s_axi_arready     ( 1'b 0 ),
//  .s_axi_wdata       ( ),
//  .s_axi_wuser       ( ),
//  .s_axi_wstrb       ( ),
//  .s_axi_wready      ( 1'b 0 ),
//  .s_axi_wlast       ( ),
//  .s_axi_wvalid      ( ),
//  .s_axi_bvalid      ( 1'b 0 ),
//  .s_axi_bready      ( ),
//  .s_axi_rready      ( ),
//  .s_axi_rvalid      ( 1'b 0 )
//);
//
//traffic_chk
//#(
//  .C_CHK_MAS_TRAFFIC      (0),
//  .C_CHK_TRAFFIC_MAS_SLV  (0), 
//  .C_AXI_DATA_WIDTH       ( 32 ),
//  .C_AXI_ID_WIDTH         ( 6  ),
//  .C_AXI_ADDR_WIDTH       ( 32 ),
//  .C_AXI_LEN_WIDTH        ( 8  ),
//  .C_AXI_BRST_WIDTH       ( 2  ),
//  .C_AXI_STB_WIDTH        ( 4  ),
//  .C_AXI_SIZE_WIDTH       ( 3  ),
//  .C_AXI_RESP_WIDTH       ( 2  ),
//  .C_AXI_WUSER_WIDTH      ( 4 )
//)
//traffic_chk_inst
//(
//  .m_axi_aclk            ( clk_out_100   ),
//  .m_axi_reset_n         ( traffic_gen_chk_reset_r ),
//  .m_axi_awvalid         ( m_axi_awvalid ),
//  .m_axi_awaddr          ( m_axi_awaddr  ),
//  .m_axi_awburst         ( m_axi_awburst ),
//  .m_axi_awid            ( m_axi_awid    ),
//  .m_axi_awlen           ( m_axi_awlen   ),
//  .m_axi_awsize          ( m_axi_awsize  ),
//  .m_axi_awready         ( m_axi_awready ),
//  .m_axi_araddr          ( m_axi_araddr  ),
//  .m_axi_arvalid         ( m_axi_arvalid ),
//  .m_axi_arburst         ( m_axi_arburst ),
//  .m_axi_arid            ( m_axi_arid    ),
//  .m_axi_arlen           ( m_axi_arlen   ),
//  .m_axi_arsize          ( m_axi_arsize  ),
//  .m_axi_arready         ( m_axi_arready ),
//  .m_axi_wdata           ( m_axi_wdata   ),
//  .m_axi_wuser           ( m_axi_wuser   ),
//  .m_axi_wstrb           ( m_axi_wstrb   ),
//  .m_axi_wready          ( m_axi_wready  ),
//  .m_axi_wlast           ( m_axi_wlast   ),
//  .m_axi_wvalid          ( m_axi_wvalid  ),
//  .s_axi_aclk            ( 1'b 0 ),
//  .s_axi_reset_n         ( 1'b 1 ),
//  .s_axi_bvalid          ( 1'b 0 ),
//  .s_axi_bready          ( 1'b 0 ),
//  .s_axi_rready          ( 1'b 0 ),
//  .s_axi_rvalid          ( 1'b 0 ),
//  .s_axi_bid             ( 6'b 0 ),
//  .s_axi_bresp           ( 2'b 0 ),
//  .s_axi_rlast           ( 1'b 0 ),
//  .s_axi_rdata           ( 32'b 0 ),
//  .s_axi_rid             ( 6'b 0 ),
//  .s_axi_rresp           ( 2'b 0 ),
//  .aw_error              ( aw_error      ),
//  .ar_error              ( ar_error      ),
//  .w_error               ( w_error       ),
//  .r_error               ( r_error       ),
//  .b_error               ( b_error       )
//);


aurora_exdes #(
    .USE_SIMULATE_VERSION_OF_IP(USE_SIMULATE_VERSION_OF_IP) // parameter USE_SIMULATE_VERSION_OF_IP = 0
)
 aurora_partner_inst
(
  .RESET                   ( reset           ),
  .HARD_ERR                (                           ),
  .SOFT_ERR                (                           ),
  .LANE_UP                 (                           ),
//  .DO_CC                   ( do_cc_slv                 ),
  .mmcm_not_locked         ( aurora_mmcm_not_locked_slv),
  .reset_pb                ( aurora_rst_out_slv        ),
  .CHANNEL_UP              ( t_axi_auro_channel_up_slv ),
  .INIT_CLK_P              ( INIT_CLK_P                ),
  .INIT_CLK_N              ( INIT_CLK_N                ),
  .PMA_INIT                ( PMA_INIT_OUT              ),
  .GTXQ1_P                 ( GTXQ1_P                   ),
  .GTXQ1_N                 ( GTXQ1_N                   ),
  .RXP                     ( aurora_rx_p_slv           ),
  .RXN                     ( aurora_rx_n_slv           ),
  .TXP                     ( aurora_tx_p_slv           ),
  .TXN                     ( aurora_tx_n_slv           ),
  .tx_tdata_i              ( t_axi_auro_tx_tdata_slv   ), 
  .tx_tvalid_i             ( t_axi_auro_tx_tvalid_slv  ),
  .tx_tready_i             ( t_axi_auro_tx_tready_slv  ),
  .rx_tdata_i              ( t_axi_auro_rx_tdata_slv   ), 
  .rx_tvalid_i             ( t_axi_auro_rx_tvalid_slv  ),
  .init_clk_i              ( INIT_clk_slv              ),
  .user_clk_i              ( t_axi_phy_clk_slv         )
);
endmodule                                          
