 ///////////////////////////////////////////////////////////////////////////////
 //
 // Company:  Xilinx
 //
 //
 //
 // (c) Copyright 2009 - 2013 Xilinx, Inc. All rights reserved.
 //
 // This file contains confidential and proprietary information
 // of Xilinx, Inc. and is protected under U.S. and
 // international copyright and other intellectual property
 // laws.
 //
 // DISCLAIMER
 // This disclaimer is not a license and does not grant any
 // rights to the materials distributed herewith. Except as
 // otherwise provided in a valid license issued to you by
 // Xilinx, and to the maximum extent permitted by applicable
 // law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND
 // WITH ALL FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES
 // AND CONDITIONS, EXPRESS, IMPLIED, OR STATUTORY, INCLUDING
 // BUT NOT LIMITED TO WARRANTIES OF MERCHANTABILITY, NON-
 // INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE; and
 // (2) Xilinx shall not be liable (whether in contract or tort,
 // including negligence, or under any other theory of
 // liability) for any loss or damage of any kind or nature
 // related to, arising under or in connection with these
 // materials, including for any direct, or any indirect,
 // special, incidental, or consequential loss or damage
 // (including loss of data, profits, goodwill, or any type of
 // loss or damage suffered as a result of any action brought
 // by a third party) even if such damage or loss was
 // reasonably foreseeable or Xilinx had been advised of the
 // possibility of the same.
 //
 // CRITICAL APPLICATIONS
 // Xilinx products are not designed or intended to be fail-
 // safe, or for use in any application requiring fail-safe
 // performance, such as life-support or safety devices or
 // systems, Class III medical devices, nuclear facilities,
 // applications related to the deployment of airbags, or any
 // other applications that could lead to death, personal
 // injury, or severe property or environmental damage
 // (individually and collectively, "Critical
 // Applications"). Customer assumes the sole risk and
 // liability of any use of Xilinx products in Critical
 // Applications, subject only to applicable laws and
 // regulations governing limitations on product liability.
 //
 // THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS
 // PART OF THIS FILE AT ALL TIMES.
 //
 ///////////////////////////////////////////////////////////////////////////////
 `timescale 1 ns / 10 ps
(* DowngradeIPIdentifiedWarnings="yes" *)
 module aurora_exdes  #
 (
     parameter   USE_CORE_TRAFFIC     =   1,
     parameter USE_SIMULATE_VERSION_OF_IP = 0,
     parameter   EXAMPLE_SIMULATION=   0       // change to '1' for post implemenation simulations - steve farmer - this really doesn't seem to do anything even with the translate off below
      //pragma translate_off
        | 1
      //pragma translate_on
 )
 (
     RESET,
 
     // Error Detection Interface
     HARD_ERR,
     SOFT_ERR,
     // Status
     LANE_UP,
     //DO_CC,
     mmcm_not_locked,
     reset_pb,
     CHANNEL_UP,
 
     // System Interface
     INIT_CLK_P,
     INIT_CLK_N,
     PMA_INIT,
     // GTX Reference Clock Interface
     GTXQ1_P,
     GTXQ1_N,
 
 
     // GTX Serial I/O
     RXP,
     RXN,
     TXP,
     TXN,

     init_clk_i,
     user_clk_i,

     tx_tdata_i, 
     tx_tvalid_i,         
     tx_tready_i,         
     rx_tdata_i,  
     rx_tvalid_i

 );
 
       localparam DATA_WIDTH = 64;
       localparam NUM_LANES = DATA_WIDTH/64;
        
 //***********************************Port Declarations*******************************
 
       input                   RESET; 
 
     // Error Detection Interface
       output                  HARD_ERR; 
       output                  SOFT_ERR; 
 
     // Status
       output                  LANE_UP;
       //input                   DO_CC;
       output                  mmcm_not_locked;
       input                   reset_pb;
       output                  CHANNEL_UP; 
 
       input                   PMA_INIT; 
       input                   INIT_CLK_P; 
       input                   INIT_CLK_N; 
 
     // GTX Reference Clock Interface
       input                   GTXQ1_P; 
       input                   GTXQ1_N; 
 
     // GTX Serial I/O
       input  [0:NUM_LANES-1]  RXP; 
       input  [0:NUM_LANES-1]  RXN; 
 
       output [0:NUM_LANES-1]  TXP; 
       output [0:NUM_LANES-1]  TXN; 
 
     //TX Interface
       input  [0:DATA_WIDTH-1] tx_tdata_i; 
       input                   tx_tvalid_i;         
       output                  tx_tready_i;         

     //RX Interface
       output [0:DATA_WIDTH-1] rx_tdata_i;  
       output                  rx_tvalid_i;         
 
       output                  init_clk_i; 
       output                  user_clk_i; 
 
 //************************External Register Declarations*****************************
 
     //Error reporting signals
       reg                     HARD_ERR; 
       reg                     SOFT_ERR; 
 
     //Global signals
       reg   [0:NUM_LANES-1]   LANE_UP; 
       reg                     CHANNEL_UP; 
 
 //********************************Wire Declarations**********************************
     
     //Dut1
    //TX Interface
 
(* mark_debug = "true" *)       wire  [0:DATA_WIDTH-1]  tx_tdata_i; 
(* mark_debug = "true" *)       wire                    tx_tvalid_i;         
(* mark_debug = "true" *)       wire                    tx_tready_i;         
 
     //RX Interface
(* mark_debug = "true" *)       wire  [0:DATA_WIDTH-1]  rx_tdata_i;  
(* mark_debug = "true" *)       wire                    rx_tvalid_i;         
 
 
     //Error Detection Interface
(* mark_debug = "true" *)       wire                    hard_err_i;         
(* mark_debug = "true" *)       wire                    soft_err_i;         
 
     //Status
(* mark_debug = "true" *)       wire                    channel_up_i;         
(* mark_debug = "true" *)       wire  [0:NUM_LANES-1]   lane_up_i; 
 
 
     //System Interface
       wire                 system_reset_i;
       wire                 reset_i ; 
       wire                 gt_rxcdrovrden_i ; 
       wire                 powerdown_i ; 
       wire      [2:0]      loopback_i ; 
(* mark_debug = "true" *)       wire                 gt_pll_lock_i ; 
       wire                 tx_out_clk_i ; 
 
     // clock
       (* KEEP = "TRUE" *) wire               user_clk_i; 
       (* KEEP = "TRUE" *) wire               sync_clk_i; 
       (* KEEP = "TRUE" *) wire               init_clk_i  /* synthesis syn_keep = 1 */; 

       wire    [9:0] drpaddr_in_i;
       wire    [15:0]     drpdi_in_i;
       wire               drp_clk_i = init_clk_i;
       wire    [15:0]     drpdo_out_i; 
       wire               drprdy_out_i; 
       wire               drpen_in_i; 
       wire               drpwe_in_i;

 
       wire               link_reset_i;
       wire               rx_cdrovrden_i;



 //*********************************Main Body of Code**********************************
 
     //____________________________Register User I/O___________________________________
 
     // Register User Outputs from core.
     always @(posedge user_clk_i)
     begin
         HARD_ERR         <=  hard_err_i;
         SOFT_ERR         <=  soft_err_i;
         LANE_UP          <=  lane_up_i;
         CHANNEL_UP       <=  channel_up_i;
     end
 
     //____________________________Register User I/O___________________________________
 
     // System Interface
     assign  power_down_i      =   1'b0;
    // Native DRP Interface
     assign  drpaddr_in_i                     =  10'h0;
     assign  drpdi_in_i                       =  16'h0;
     assign  drpwe_in_i     =  1'b0; 
     assign  drpen_in_i     =  1'b0; 



     assign  reset_i  =   system_reset_i;
     assign  gt_rxcdrovrden_i  =  1'b0;
     assign  loopback_i  =  3'b000;

     assign init_clk_i = INIT_CLK_P;

 
if (USE_SIMULATE_VERSION_OF_IP) begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
     //___________________________Module Instantiations_________________________________

    aurora_64b66b_0_simulate aurora_block_inst (
        // TX AXI4-S Interface
         .s_axi_tx_tdata(tx_tdata_i),
         .s_axi_tx_tvalid(tx_tvalid_i),
         .s_axi_tx_tready(tx_tready_i),
 
         //.do_cc(DO_CC),
 
        // RX AXI4-S Interface
         .m_axi_rx_tdata(rx_tdata_i),
         .m_axi_rx_tvalid(rx_tvalid_i),
          
 
 
        // GT Serial I/O
         .rxp(RXP),
         .rxn(RXN),
 
         .txp(TXP),
         .txn(TXN),
 
 
        //GT Reference Clock Interface
         
        .gt_refclk1_p (GTXQ1_P),
        .gt_refclk1_n (GTXQ1_N),

        // Error Detection Interface
         .hard_err(hard_err_i),
         .soft_err(soft_err_i),
 
        // Status
         .channel_up(channel_up_i),
         .lane_up(lane_up_i),
 
        // System Interface
         .user_clk_out(user_clk_i),
         .mmcm_not_locked_out(mmcm_not_locked),
         .sync_clk_out(sync_clk_i),
         //.reset(reset_i),
         .reset_pb(reset_pb),
         .gt_rxcdrovrden_in(gt_rxcdrovrden_i),
         .power_down(power_down_i),
         .loopback(loopback_i),
         .pma_init(PMA_INIT),
         .gt_pll_lock(gt_pll_lock_i),
    //---------------------- GT DRP Ports ----------------------
         .gt0_drpaddr('d0),
         .gt0_drpdi(drpdi_in_i),
         .gt0_drpdo(drpdo_out_i), 
         .gt0_drprdy(drprdy_out_i), 
         .gt0_drpen(drpen_in_i), 
         .gt0_drpwe(drpwe_in_i), 
         .init_clk(INIT_CLK_P),
         .link_reset_out(link_reset_i),
         .sys_reset_out(system_reset_i),
         .tx_out_clk(tx_out_clk_i)

     );
end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_1
else begin : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0
     //___________________________Module Instantiations_________________________________

    aurora_64b66b_0  
////ERROR: [Synth 8-7136] In the module 'aurora_64b66b_0' declared at 'v:/aurora/axi_test/design/vivado/vivado_ip_regeneration/vivado_ip_regeneration.gen/sources_1/ip/aurora_64b66b_0/aurora_64b66b_0.v:70', parameter 'EXAMPLE_SIMULATION' used as named parameter override, does not exist [V:/aurora/axi_test/design/source/imports/aurora_exdes.v:309]
//    #(
//          .EXAMPLE_SIMULATION(0) // parameter   EXAMPLE_SIMULATION =   0      
//     )
     aurora_block_inst
     (
        // TX AXI4-S Interface
         .s_axi_tx_tdata(tx_tdata_i),
         .s_axi_tx_tvalid(tx_tvalid_i),
         .s_axi_tx_tready(tx_tready_i),
 
         //.do_cc(DO_CC),
 
        // RX AXI4-S Interface
         .m_axi_rx_tdata(rx_tdata_i),
         .m_axi_rx_tvalid(rx_tvalid_i),
          
 
 
        // GT Serial I/O
         .rxp(RXP),
         .rxn(RXN),
 
         .txp(TXP),
         .txn(TXN),
 
 
        //GT Reference Clock Interface
         
        .gt_refclk1_p (GTXQ1_P),
        .gt_refclk1_n (GTXQ1_N),

        // Error Detection Interface
         .hard_err(hard_err_i),
         .soft_err(soft_err_i),
 
        // Status
         .channel_up(channel_up_i),
         .lane_up(lane_up_i),
 
        // System Interface
         .user_clk_out(user_clk_i),
         .mmcm_not_locked_out(mmcm_not_locked),
         .sync_clk_out(sync_clk_i),
         //.reset(reset_i),
         .reset_pb(reset_pb),
         .gt_rxcdrovrden_in(gt_rxcdrovrden_i),
         .power_down(power_down_i),
         .loopback(loopback_i),
         .pma_init(PMA_INIT),
         .gt_pll_lock(gt_pll_lock_i),
    //---------------------- GT DRP Ports ----------------------
         .gt0_drpaddr('d0),
         .gt0_drpdi(drpdi_in_i),
         .gt0_drpdo(drpdo_out_i), 
         .gt0_drprdy(drprdy_out_i), 
         .gt0_drpen(drpen_in_i), 
         .gt0_drpwe(drpwe_in_i), 
         .init_clk(INIT_CLK_P),
         .link_reset_out(link_reset_i),
         .sys_reset_out(system_reset_i),
         .tx_out_clk(tx_out_clk_i)

     );
end : IF_USE_SIMULATE_VERSION_OF_IP_EQUALS_0

 endmodule

