#******************************************************************************
# (c) Copyright 2012 - 2013 Xilinx, Inc. All rights reserved.
#
# This file contains confidential and proprietary information
# of Xilinx, Inc. and is protected under U.S. and
# international copyright and other intellectual property
# laws.
#
# DISCLAIMER
# This disclaimer is not a license and does not grant any
# rights to the materials distributed herewith. Except as
# otherwise provided in a valid license issued to you by
# Xilinx, and to the maximum extent permitted by applicable
# law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
# WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
# AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
# BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
# INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
# (2) Xilinx shall not be liable (whether in contract or tort,
# including negligence, or under any other theory of
# liability) for any loss or damage of any kind or nature
# related to, arising under or in connection with these
# materials, including for any direct, or any indirect,
# special, incidental, or consequential loss or damage
# (including loss of data, profits, goodwill, or any type of
# loss or damage suffered as a result of any action brought
# by a third party) even if such damage or loss was
# reasonably foreseeable or Xilinx had been advised of the
# possibility of the same.
#
# CRITICAL APPLICATIONS
# Xilinx products are not designed or intended to be fail-
# safe, or for use in any application requiring fail-safe
# performance, such as life-support or safety devices or
# systems, Class III medical devices, nuclear facilities,
# applications related to the deployment of airbags, or any
# other applications that could lead to death, personal
# injury, or severe property or environmental damage
# (individually and collectively, "Critical
# Applications"). Customer assumes the sole risk and
# liability of any use of Xilinx products in Critical
# Applications, subject only to applicable laws and
# regulations governing limitations on product liability.
#
# THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
# PART OF THIS FILE AT ALL TIMES.
#*******************************************************************************

# CHANGE THE CLOCK PERIODS BASED ON THE INPUT SYSTEM CLOCK USED #
#create_clock -name clk_100 -period 10 [get_nets clk_out_100]



create_clock -name GTXQ1_left_i -period 8.0 [get_ports GTXQ1_P]



#
#

# UNCOMMENT THE FOLLOWING LINES AND CHANGE THE IOSTANDARDS BASED ON THE BOARD USED
################Following XDC specific to KC705############################
#set_property LOC AD11 [ get_ports clk_200_n]
#set_property IOSTANDARD LVDS [ get_ports clk_200_p]
#set_property LOC AD12 [ get_ports clk_200_p]
#set_property IOSTANDARD LVDS [ get_ports clk_200_n]
#create_clock -period "5" -name clk_200_p [get_ports clk_200_p]

#set_property LOC K28 [ get_ports INIT_CLK_P]
#set_property LOC K29 [ get_ports INIT_CLK_N]
#set_property IOSTANDARD LVDS_25 [ get_ports INIT_CLK_P]
#set_property IOSTANDARD LVDS_25 [ get_ports INIT_CLK_N]
create_clock -name TS_INIT_CLK -period 6.206 [get_ports INIT_CLK_P]

#set_property PACKAGE_PIN G12 [get_ports reset]
#set_property IOSTANDARD LVCMOS25 [get_ports reset]
#AXI Chip2Chip Status Signals
#set_property IOSTANDARD LVCMOS15 [get_ports t_axi_calib_done_out_slv]
#set_property IOSTANDARD LVCMOS15 [get_ports t_axi_calib_error_out_slv]
#set_property PACKAGE_PIN AA8 [get_ports t_axi_calib_done_out_slv]
#set_property PACKAGE_PIN AB8 [get_ports t_axi_calib_error_out_slv]
#set_property IOSTANDARD LVCMOS15 [get_ports t_axi_phy_error_out_slv]
#set_property PACKAGE_PIN AC9 [get_ports t_axi_phy_error_out_slv]
#SGMII
#set_property PACKAGE_PIN G8 [get_ports GTXQ1_P]
#set_property PACKAGE_PIN G7 [get_ports GTXQ1_N]
#set_property IOSTANDARD LVCMOS15 [get_ports PMA_INIT]
#set_property PACKAGE_PIN AA12 [get_ports PMA_INIT]
#SMA MGT 
#set_property PACKAGE_PIN K6 [get_ports aurora_rx_p_slv]
#set_property PACKAGE_PIN K5 [get_ports aurora_rx_n_slv]
#set_property PACKAGE_PIN K2 [get_ports aurora_tx_p_slv]
#set_property PACKAGE_PIN K1 [get_ports aurora_tx_n_slv]
#Status signals for indicating errors
#set_property PACKAGE_PIN AB9 [get_ports axi4_error]
#set_property IOSTANDARD LVCMOS15 [get_ports axi4_error]
#set_property PACKAGE_PIN Y29 [get_ports start_traffic]
#set_property IOSTANDARD LVCMOS25 [get_ports start_traffic]
# COMMENT THE FOLLOWING LINE FOR CONSTRAINING THE PINS AND IMPLEMENTING ON BOARD
set_property BITSTREAM.GENERAL.UNCONSTRAINEDPINS Allow [current_design]

create_waiver -type CDC -id CDC-7  -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *sync_reset_out_reg/C}]                          -to [get_pins -quiet -hierarchical -filter {NAME=~ *fifo_reset_reg/PRE}]                -description {CDC-7 for asynchronous reset}
create_waiver -type CDC -id CDC-7  -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *axi_aresetn_sync_reg[3]/C}]                     -to [get_pins -quiet -hierarchical -filter {NAME=~ *br_fifo_reset_reg/PRE}]             -description {CDC-7 for asynchronous reset}
create_waiver -type CDC -id CDC-7  -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *axi_aresetn_sync_reg[3]/C}]                     -to [get_pins -quiet -hierarchical -filter {NAME=~ *aw_fifo_reset_reg/PRE}]             -description {CDC-7 for asynchronous reset}
create_waiver -type CDC -id CDC-10 -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *u_rst_done_sync_rx/stg3_reg/C}]                 -to [get_pins -quiet -hierarchical -filter {NAME=~ *stg1_aurora_64b66b_0_cdc_to_reg/D}] -description {CDC-10 for Combinational logic detected before a synchronizer in Aurora}
create_waiver -type CDC -id CDC-10 -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *reset_init_assertion_reg/C}]                    -to [get_pins -quiet -hierarchical -filter {NAME=~ *stg1_aurora_64b66b_0_cdc_to_reg/D}] -description {CDC-10 for Combinational logic detected before a synchronizer in Aurora}
create_waiver -type CDC -id CDC-11 -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *dly_gt_rst_r_reg[18]/C}]                        -to [get_pins -quiet -hierarchical -filter {NAME=~ *stg1_aurora_64b66b_0_cdc_to_reg/D}] -description {CDC-11 for Aurora Fan-out from launch flop to destination clock}
create_waiver -type CDC -id CDC-11 -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *axi_aresetn_sync_reg[3]/C}]                     -to [get_pins -quiet -hierarchical -filter {NAME=~ *sync_reset_flop_reg[0]/PRE}]        -description {CDC-11 for Fan-out from launch flop to destination clock}
create_waiver -type CDC -id CDC-11 -user axi_chip2chip -from [get_pins -quiet -hierarchical -filter {NAME=~ *axi_aresetn_sync_reg[3]/C}]                     -to [get_pins -quiet -hierarchical -filter {NAME=~ *aurora_rst_out_cdc_to_reg/PRE}]    -description {CDC-11 for Fan-out from launch flop to destination clock}
