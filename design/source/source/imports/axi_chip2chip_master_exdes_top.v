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
module axi_chip2chip_master_exdes_top (
   input  wire        clk_200_p,
   input  wire        clk_200_n,
   input  wire        reset,
   input  wire        start_traffic,

    output wire                  t_axi_calib_done_out_mas,
    output wire                  t_axi_calib_error_out_mas,
    output wire                  axi_c2c_link_error_out_mas,
    input   wire                  GTXQ1_P,
    input   wire                  GTXQ1_N,
    input   wire                  PMA_INIT,
    input   wire                  INIT_CLK_P,
    input   wire                  INIT_CLK_N,
    output  wire                  t_axi_phy_error_out_mas,
    input   wire                  aurora_rx_p_mas,
    input   wire                  aurora_rx_n_mas,
    output  wire                  aurora_tx_p_mas, 
    output  wire                  aurora_tx_n_mas,
    output wire                   axi4_error,
    output wire                  clk_out_100,
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
    input  wire                  s_axi_rready
    );

axi_chip2chip_master_exdes 
#(
 )
axi_chip2chip_master_exdes_dut_inst
(
    .clk_200_p(clk_200_p),                                   // input  wire        clk_200_p,
    .clk_200_n(clk_200_n),                                   // input  wire        clk_200_n,
    .reset(reset),                                           // input  wire        reset,
    .start_traffic(start_traffic),                           // input  wire        start_traffic,
    .t_axi_calib_done_out_mas(t_axi_calib_done_out_mas),     // output wire        t_axi_calib_done_out_mas,
    .t_axi_calib_error_out_mas(t_axi_calib_error_out_mas),   // output wire        t_axi_calib_error_out_mas,
    .axi_c2c_link_error_out_mas(axi_c2c_link_error_out_mas), // output wire        axi_c2c_link_error_out_mas,
    .GTXQ1_P(GTXQ1_P),                                       // input   wire       GTXQ1_P,
    .GTXQ1_N(GTXQ1_N),                                       // input   wire       GTXQ1_N,
    .PMA_INIT(PMA_INIT),                                     // input   wire       PMA_INIT,
    .INIT_CLK_P(INIT_CLK_P),                                 // input   wire       INIT_CLK_P,
    .INIT_CLK_N(INIT_CLK_N),                                 // input   wire       INIT_CLK_N,
    .t_axi_phy_error_out_mas(t_axi_phy_error_out_mas),       // output  wire       t_axi_phy_error_out_mas,
    .aurora_rx_p_mas(aurora_rx_p_mas),                       // input   wire       aurora_rx_p_mas,
    .aurora_rx_n_mas(aurora_rx_n_mas),                       // input   wire       aurora_rx_n_mas,
    .aurora_tx_p_mas(aurora_tx_p_mas),                       // output  wire       aurora_tx_p_mas,
    .aurora_tx_n_mas(aurora_tx_n_mas),                       // output  wire       aurora_tx_n_mas,

    .clk_out_100(clk_out_100),     // output wire                  clk_out_100,
    .s_axi_awid(s_axi_awid),       // input  wire [6-1:0]          s_axi_awid,
    .s_axi_awaddr(s_axi_awaddr),   // input  wire [32-1:0]         s_axi_awaddr,
    .s_axi_awlen(s_axi_awlen),     // input  wire [8-1:0]          s_axi_awlen,
    .s_axi_awsize(s_axi_awsize),   // input  wire [3-1:0]          s_axi_awsize,
    .s_axi_awburst(s_axi_awburst), // input  wire [2-1:0]          s_axi_awburst,
    .s_axi_awvalid(s_axi_awvalid), // input  wire                  s_axi_awvalid,
    .s_axi_awready(s_axi_awready), // output wire                  s_axi_awready,
    .s_axi_wuser(s_axi_wuser),     // input  wire [4-1:0]          s_axi_wuser,
    .s_axi_wdata(s_axi_wdata),     // input  wire [32-1:0]         s_axi_wdata,
    .s_axi_wstrb(s_axi_wstrb),     // input  wire [4-1:0]          s_axi_wstrb,
    .s_axi_wlast(s_axi_wlast),     // input  wire                  s_axi_wlast,
    .s_axi_wvalid(s_axi_wvalid),   // input  wire                  s_axi_wvalid,
    .s_axi_wready(s_axi_wready),   // output wire                  s_axi_wready,
    .s_axi_bid(s_axi_bid),         // output wire [6-1:0]          s_axi_bid,
    .s_axi_bresp(s_axi_bresp),     // output wire [2-1:0]          s_axi_bresp,
    .s_axi_bvalid(s_axi_bvalid),   // output wire                  s_axi_bvalid,
    .s_axi_bready(s_axi_bready),   // input  wire                  s_axi_bready,
    .s_axi_arid(s_axi_arid),       // input  wire [6-1:0]          s_axi_arid,
    .s_axi_araddr(s_axi_araddr),   // input  wire [32-1:0]         s_axi_araddr,
    .s_axi_arlen(s_axi_arlen),     // input  wire [8-1:0]          s_axi_arlen,
    .s_axi_arsize(s_axi_arsize),   // input  wire [3-1:0]          s_axi_arsize,
    .s_axi_arburst(s_axi_arburst), // input  wire [2-1:0]          s_axi_arburst,
    .s_axi_arvalid(s_axi_arvalid), // input  wire                  s_axi_arvalid,
    .s_axi_arready(s_axi_arready), // output wire                  s_axi_arready,
    .s_axi_rid(s_axi_rid),         // output wire [6-1:0]          s_axi_rid,
    .s_axi_rdata(s_axi_rdata),     // output wire [32-1:0]         s_axi_rdata,
    .s_axi_rresp(s_axi_rresp),     // output wire [2-1:0]          s_axi_rresp,
    .s_axi_rlast(s_axi_rlast),     // output wire                  s_axi_rlast,
    .s_axi_rvalid(s_axi_rvalid),   // output wire                  s_axi_rvalid,
    .s_axi_rready(s_axi_rready)    // input  wire                  s_axi_rready

);

endmodule                                          
