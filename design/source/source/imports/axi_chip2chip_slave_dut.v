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
module axi_chip2chip_slave_dut #(
    parameter USE_SIMULATE_VERSION_OF_IP = 0
)
(
  input  wire                  axi_c2c_phy_clk_slv,
  input  wire                  t_axi_auro_channel_up_slv,
  output wire                  t_axi_auro_tx_tvalid_slv,
  input  wire                  t_axi_auro_rx_tvalid_slv,
  input  wire                  t_axi_auro_tx_tready_slv,
  output wire [64-1:0]         t_axi_auro_tx_tdata_slv,
  input  wire [64-1:0]         t_axi_auro_rx_tdata_slv,
  output wire                  do_cc_slv,
  input  wire                  INIT_clk_slv,
  input  wire                  pma_init_in_slv,
  output wire                  pma_init_out_slv,
  input  wire                  aurora_mmcm_not_locked_slv,
  output wire                  aurora_rst_out_slv,
  output wire                  t_axi_phy_error_out_slv,
  // C_AXI Master FPGA interface
  // C_AXI slave FPGA interface
  input                        m_aclk,
  input                        m_aresetn,
  output wire [6-1:0]          m_axi_awid,
  output wire [32-1:0]        m_axi_awaddr,
  output wire [8-1:0]          m_axi_awlen,
  output wire [3-1:0]          m_axi_awsize,
  output wire [2-1:0]          m_axi_awburst,
  output wire                  m_axi_awvalid,
  input  wire                  m_axi_awready,
  output wire [4-1:0]          m_axi_wuser,
  output wire [32-1:0]         m_axi_wdata,
  output wire [4-1:0]          m_axi_wstrb,
  output wire                  m_axi_wlast,
  output wire                  m_axi_wvalid,
  input  wire                  m_axi_wready,
  input  wire [6-1:0]          m_axi_bid,
  input  wire [2-1:0]          m_axi_bresp,
  input  wire                  m_axi_bvalid,
  output wire                  m_axi_bready,
  output wire [6-1:0]          m_axi_arid,
  output wire [32-1:0]        m_axi_araddr,
  output wire [8-1:0]          m_axi_arlen,
  output wire [3-1:0]          m_axi_arsize,
  output wire [2-1:0]          m_axi_arburst,
  output wire                  m_axi_arvalid,
  input  wire                  m_axi_arready,
  input  wire [6-1:0]          m_axi_rid,
  input  wire [32-1:0]         m_axi_rdata,
  input  wire [2-1:0]          m_axi_rresp,
  input  wire                  m_axi_rlast,
  input  wire                  m_axi_rvalid,
  output wire                  m_axi_rready,
  input  wire [4-1:0]          axi_c2c_s2m_intr_in,
  output wire [4-1:0]          axi_c2c_m2s_intr_out,
  output wire                  t_axi_calib_done_out_slv,
  output wire                  t_axi_calib_error_out_slv
);

    if (USE_SIMULATE_VERSION_OF_IP) begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
      axi_chip2chip_slave_simulate axi_chip2chip_slave_inst_0
      (
          .m_aclk                           ( m_aclk    ),
          .m_aresetn                        ( m_aresetn ),
          .m_axi_awid                       ( m_axi_awid    ),
          .m_axi_awaddr                     ( m_axi_awaddr  ),
          .m_axi_awlen                      ( m_axi_awlen   ),
          .m_axi_awsize                     ( m_axi_awsize  ),
          .m_axi_awburst                    ( m_axi_awburst ),
          .m_axi_awvalid                    ( m_axi_awvalid ),
          .m_axi_awready                    ( m_axi_awready ),
          .m_axi_wuser                      ( m_axi_wuser   ),
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
          .axi_c2c_s2m_intr_in              ( axi_c2c_s2m_intr_in  ),
          .axi_c2c_m2s_intr_out             ( axi_c2c_m2s_intr_out ),
          .axi_c2c_phy_clk                  ( axi_c2c_phy_clk_slv),
          .axi_c2c_aurora_channel_up        ( t_axi_auro_channel_up_slv ),
          .axi_c2c_aurora_tx_tready         ( t_axi_auro_tx_tready_slv ),
          .axi_c2c_aurora_tx_tdata          ( t_axi_auro_tx_tdata_slv  ),
          .axi_c2c_aurora_tx_tvalid         ( t_axi_auro_tx_tvalid_slv ),
          .axi_c2c_aurora_rx_tdata          ( t_axi_auro_rx_tdata_slv  ),
          .axi_c2c_aurora_rx_tvalid         ( t_axi_auro_rx_tvalid_slv ),
          .aurora_do_cc                     ( do_cc_slv                ),
          .aurora_init_clk                  ( INIT_clk_slv             ),
          .aurora_pma_init_in               ( pma_init_in_slv          ),
          .aurora_pma_init_out              ( pma_init_out_slv         ),
          .aurora_mmcm_not_locked           ( aurora_mmcm_not_locked_slv),
          .aurora_reset_pb                  ( aurora_rst_out_slv       ),
          .axi_c2c_config_error_out         ( t_axi_phy_error_out_slv ),
          .axi_c2c_link_status_out          ( t_axi_calib_done_out_slv ),
          .axi_c2c_multi_bit_error_out      ( t_axi_calib_error_out_slv )
        );
    end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
    else begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0
      axi_chip2chip_slave axi_chip2chip_slave_inst_0
      (
          .m_aclk                           ( m_aclk    ),
          .m_aresetn                        ( m_aresetn ),
          .m_axi_awid                       ( m_axi_awid    ),
          .m_axi_awaddr                     ( m_axi_awaddr  ),
          .m_axi_awlen                      ( m_axi_awlen   ),
          .m_axi_awsize                     ( m_axi_awsize  ),
          .m_axi_awburst                    ( m_axi_awburst ),
          .m_axi_awvalid                    ( m_axi_awvalid ),
          .m_axi_awready                    ( m_axi_awready ),
          .m_axi_wuser                      ( m_axi_wuser   ),
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
          .axi_c2c_s2m_intr_in              ( axi_c2c_s2m_intr_in  ),
          .axi_c2c_m2s_intr_out             ( axi_c2c_m2s_intr_out ),
          .axi_c2c_phy_clk                  ( axi_c2c_phy_clk_slv),
          .axi_c2c_aurora_channel_up        ( t_axi_auro_channel_up_slv ),
          .axi_c2c_aurora_tx_tready         ( t_axi_auro_tx_tready_slv ),
          .axi_c2c_aurora_tx_tdata          ( t_axi_auro_tx_tdata_slv  ),
          .axi_c2c_aurora_tx_tvalid         ( t_axi_auro_tx_tvalid_slv ),
          .axi_c2c_aurora_rx_tdata          ( t_axi_auro_rx_tdata_slv  ),
          .axi_c2c_aurora_rx_tvalid         ( t_axi_auro_rx_tvalid_slv ),
          .aurora_do_cc                     ( do_cc_slv                ),
          .aurora_init_clk                  ( INIT_clk_slv             ),
          .aurora_pma_init_in               ( pma_init_in_slv          ),
          .aurora_pma_init_out              ( pma_init_out_slv         ),
          .aurora_mmcm_not_locked           ( aurora_mmcm_not_locked_slv),
          .aurora_reset_pb                  ( aurora_rst_out_slv       ),
          .axi_c2c_config_error_out         ( t_axi_phy_error_out_slv ),
          .axi_c2c_link_status_out          ( t_axi_calib_done_out_slv ),
          .axi_c2c_multi_bit_error_out      ( t_axi_calib_error_out_slv )
        );
    end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0

endmodule
