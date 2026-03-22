/******************************************************************************
-- (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
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
module axi_chip2chip_master_dut
#(
  parameter USE_SIMULATE_VERSION_OF_IP = 0
)
(
  input  wire                  axi_c2c_phy_clk_mas,
  input  wire                  t_axi_auro_channel_up_mas,
  output wire                  t_axi_auro_tx_tvalid_mas,
  input  wire                  t_axi_auro_tx_tready_mas,
  input  wire                  t_axi_auro_rx_tvalid_mas,
  output wire [64-1:0]         t_axi_auro_tx_tdata_mas,
  input  wire [64-1:0]         t_axi_auro_rx_tdata_mas,
  output wire                  do_cc_mas,
  input  wire                  INIT_clk_mas,
  input  wire                  pma_init_in_mas,
  output wire                  pma_init_out_mas,
  input  wire                  aurora_mmcm_not_locked_mas,
  output wire                  aurora_rst_out_mas,
  output wire                  t_axi_phy_error_out_mas,
  input                        s_aclk,
  input                        s_aresetn,
  input  wire [6-1:0]          s_axi_awid,
  input  wire [32-1:0]         s_axi_awaddr,
  input  wire [8-1:0]          s_axi_awlen,
  input  wire [3-1:0]          s_axi_awsize,
  input  wire [2-1:0]          s_axi_awburst,
  input  wire                  s_axi_awvalid,
  output wire                  s_axi_awready,
  input  wire [4-1:0]          s_axi_wuser,
  input  wire [32-1:0]         s_axi_wdata,
  input  wire [4-1:0]          s_axi_wstrb,
  input  wire                  s_axi_wlast,
  input  wire                  s_axi_wvalid,
  output wire                  s_axi_wready,
  output wire [6-1:0]          s_axi_bid,
  output wire [2-1:0]          s_axi_bresp,
  output wire                  s_axi_bvalid,
  input  wire                  s_axi_bready,
  input  wire [6-1:0]          s_axi_arid,
  input  wire [32-1:0]         s_axi_araddr,
  input  wire [8-1:0]          s_axi_arlen,
  input  wire [3-1:0]          s_axi_arsize,
  input  wire [2-1:0]          s_axi_arburst,
  input  wire                  s_axi_arvalid,
  output wire                  s_axi_arready,
  output wire [6-1:0]          s_axi_rid,
  output wire [32-1:0]         s_axi_rdata,
  output wire [2-1:0]          s_axi_rresp,
  output wire                  s_axi_rlast,
  output wire                  s_axi_rvalid,
  input  wire                  s_axi_rready,
  input  wire [4-1:0]          axi_c2c_m2s_intr_in,
  output wire [4-1:0]          axi_c2c_s2m_intr_out,
  output wire                  t_axi_calib_done_out_mas,
  output wire                  t_axi_calib_error_out_mas,
  output wire                  axi_c2c_link_error_out_mas
);

if (USE_SIMULATE_VERSION_OF_IP) begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
  axi_chip2chip_master_simulate axi_chip2chip_master_inst_0
  (
      .s_aclk                           ( s_aclk    ),
      .s_aresetn                        ( s_aresetn ),
      .s_axi_awid                       ( s_axi_awid    ),
      .s_axi_awaddr                     ( s_axi_awaddr  ),
      .s_axi_awlen                      ( s_axi_awlen   ),
      .s_axi_awsize                     ( s_axi_awsize  ),
      .s_axi_awburst                    ( s_axi_awburst ),
      .s_axi_awvalid                    ( s_axi_awvalid ),
      .s_axi_awready                    ( s_axi_awready ),
      .s_axi_wuser                      ( s_axi_wuser   ),
      .s_axi_wdata                      ( s_axi_wdata   ),
      .s_axi_wstrb                      ( s_axi_wstrb   ),
      .s_axi_wlast                      ( s_axi_wlast   ),
      .s_axi_wvalid                     ( s_axi_wvalid  ),
      .s_axi_wready                     ( s_axi_wready  ),
      .s_axi_bid                        ( s_axi_bid     ),
      .s_axi_bresp                      ( s_axi_bresp   ),
      .s_axi_bvalid                     ( s_axi_bvalid  ),
      .s_axi_bready                     ( s_axi_bready  ),
      .s_axi_arid                       ( s_axi_arid    ),
      .s_axi_araddr                     ( s_axi_araddr  ),
      .s_axi_arlen                      ( s_axi_arlen   ),
      .s_axi_arsize                     ( s_axi_arsize  ),
      .s_axi_arburst                    ( s_axi_arburst ),
      .s_axi_arvalid                    ( s_axi_arvalid ),
      .s_axi_arready                    ( s_axi_arready ),
      .s_axi_rid                        ( s_axi_rid     ),
      .s_axi_rdata                      ( s_axi_rdata   ),
      .s_axi_rresp                      ( s_axi_rresp   ),
      .s_axi_rlast                      ( s_axi_rlast   ),
      .s_axi_rvalid                     ( s_axi_rvalid  ),
      .s_axi_rready                     ( s_axi_rready  ),
      .axi_c2c_m2s_intr_in              ( axi_c2c_m2s_intr_in  ),
      .axi_c2c_s2m_intr_out             ( axi_c2c_s2m_intr_out ),
      .axi_c2c_phy_clk                  ( axi_c2c_phy_clk_mas),
      .axi_c2c_aurora_channel_up        ( t_axi_auro_channel_up_mas ),
      .axi_c2c_aurora_tx_tready         ( t_axi_auro_tx_tready_mas ),
      .axi_c2c_aurora_tx_tdata          ( t_axi_auro_tx_tdata_mas  ),
      .axi_c2c_aurora_tx_tvalid         ( t_axi_auro_tx_tvalid_mas ),
      .axi_c2c_aurora_rx_tdata          ( t_axi_auro_rx_tdata_mas  ),
      .axi_c2c_aurora_rx_tvalid         ( t_axi_auro_rx_tvalid_mas ),
      .aurora_do_cc                     ( do_cc_mas                ),
      .aurora_init_clk                  ( INIT_clk_mas             ),
      .aurora_pma_init_in               ( pma_init_in_mas          ),
      .aurora_pma_init_out              ( pma_init_out_mas         ),
      .aurora_mmcm_not_locked           ( aurora_mmcm_not_locked_mas),
      .aurora_reset_pb                  ( aurora_rst_out_mas       ),
      .axi_c2c_config_error_out         ( t_axi_phy_error_out_mas  ),
      .axi_c2c_link_error_out           ( axi_c2c_link_error_out_mas ),
      .axi_c2c_link_status_out          ( t_axi_calib_done_out_mas ),
      .axi_c2c_multi_bit_error_out      ( t_axi_calib_error_out_mas )
    );
end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
else begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0
  axi_chip2chip_master axi_chip2chip_master_inst_0
  (
      .s_aclk                           ( s_aclk    ),
      .s_aresetn                        ( s_aresetn ),
      .s_axi_awid                       ( s_axi_awid    ),
      .s_axi_awaddr                     ( s_axi_awaddr  ),
      .s_axi_awlen                      ( s_axi_awlen   ),
      .s_axi_awsize                     ( s_axi_awsize  ),
      .s_axi_awburst                    ( s_axi_awburst ),
      .s_axi_awvalid                    ( s_axi_awvalid ),
      .s_axi_awready                    ( s_axi_awready ),
      .s_axi_wuser                      ( s_axi_wuser   ),
      .s_axi_wdata                      ( s_axi_wdata   ),
      .s_axi_wstrb                      ( s_axi_wstrb   ),
      .s_axi_wlast                      ( s_axi_wlast   ),
      .s_axi_wvalid                     ( s_axi_wvalid  ),
      .s_axi_wready                     ( s_axi_wready  ),
      .s_axi_bid                        ( s_axi_bid     ),
      .s_axi_bresp                      ( s_axi_bresp   ),
      .s_axi_bvalid                     ( s_axi_bvalid  ),
      .s_axi_bready                     ( s_axi_bready  ),
      .s_axi_arid                       ( s_axi_arid    ),
      .s_axi_araddr                     ( s_axi_araddr  ),
      .s_axi_arlen                      ( s_axi_arlen   ),
      .s_axi_arsize                     ( s_axi_arsize  ),
      .s_axi_arburst                    ( s_axi_arburst ),
      .s_axi_arvalid                    ( s_axi_arvalid ),
      .s_axi_arready                    ( s_axi_arready ),
      .s_axi_rid                        ( s_axi_rid     ),
      .s_axi_rdata                      ( s_axi_rdata   ),
      .s_axi_rresp                      ( s_axi_rresp   ),
      .s_axi_rlast                      ( s_axi_rlast   ),
      .s_axi_rvalid                     ( s_axi_rvalid  ),
      .s_axi_rready                     ( s_axi_rready  ),
      .axi_c2c_m2s_intr_in              ( axi_c2c_m2s_intr_in  ),
      .axi_c2c_s2m_intr_out             ( axi_c2c_s2m_intr_out ),
      .axi_c2c_phy_clk                  ( axi_c2c_phy_clk_mas),
      .axi_c2c_aurora_channel_up        ( t_axi_auro_channel_up_mas ),
      .axi_c2c_aurora_tx_tready         ( t_axi_auro_tx_tready_mas ),
      .axi_c2c_aurora_tx_tdata          ( t_axi_auro_tx_tdata_mas  ),
      .axi_c2c_aurora_tx_tvalid         ( t_axi_auro_tx_tvalid_mas ),
      .axi_c2c_aurora_rx_tdata          ( t_axi_auro_rx_tdata_mas  ),
      .axi_c2c_aurora_rx_tvalid         ( t_axi_auro_rx_tvalid_mas ),
      .aurora_do_cc                     ( do_cc_mas                ),
      .aurora_init_clk                  ( INIT_clk_mas             ),
      .aurora_pma_init_in               ( pma_init_in_mas          ),
      .aurora_pma_init_out              ( pma_init_out_mas         ),
      .aurora_mmcm_not_locked           ( aurora_mmcm_not_locked_mas),
      .aurora_reset_pb                  ( aurora_rst_out_mas       ),
      .axi_c2c_config_error_out         ( t_axi_phy_error_out_mas  ),
      .axi_c2c_link_error_out           ( axi_c2c_link_error_out_mas ),
      .axi_c2c_link_status_out          ( t_axi_calib_done_out_mas ),
      .axi_c2c_multi_bit_error_out      ( t_axi_calib_error_out_mas )
    );
end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0

endmodule
