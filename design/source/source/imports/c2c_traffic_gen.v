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
module traffic_gen
#(
parameter   C_GEN_MAS_TRAFFIC   = 0,
parameter   C_GEN_TRAFFIC_MAS_SLV = 0,
parameter   C_AXI_DATA_WIDTH    = 64,
parameter   C_AXI_ID_WIDTH      = 6,
parameter   C_AXI_ADDR_WIDTH    = 32,
parameter   C_AXI_LEN_WIDTH     = 8,
parameter   C_AXI_BRST_WIDTH    = 2,
parameter   C_AXI_STB_WIDTH     = 4,
parameter   C_AXI_SIZE_WIDTH    = 3,
parameter   C_AXI_RESP_WIDTH    = 2,
parameter   C_AXI_WUSER_WIDTH   = 4
)
(
  input wire                               s_axi_aclk,
  input wire                               s_axi_reset_n,

  input wire                               m_axi_aclk,
  input wire                               m_axi_reset_n,

  input wire                               m_axi_wvalid,
  input wire                               m_axi_arvalid,
  input wire                               m_axi_awvalid,
  output wire                              m_axi_arready,
  output wire                              m_axi_awready,
  output wire                              m_axi_wready,

  output wire                              m_axi_rlast,
  output wire                              m_axi_rvalid,
  output wire  [C_AXI_DATA_WIDTH-1:0]      m_axi_rdata,
  output wire  [C_AXI_ID_WIDTH-1:0]        m_axi_rid,
  output wire  [C_AXI_RESP_WIDTH-1:0]      m_axi_rresp,
  input wire                               m_axi_rready,
                                          
  output wire                              m_axi_bvalid,
  output wire  [C_AXI_ID_WIDTH-1:0]        m_axi_bid,
  output wire  [C_AXI_RESP_WIDTH-1:0]      m_axi_bresp,
  input wire                               m_axi_bready,

  output wire                              s_axi_awvalid,
  output wire  [C_AXI_ADDR_WIDTH-1:0]      s_axi_awaddr,
  output wire  [C_AXI_BRST_WIDTH-1:0]      s_axi_awburst,
  output wire  [C_AXI_ID_WIDTH-1:0]        s_axi_awid,
  output wire  [C_AXI_LEN_WIDTH-1:0]       s_axi_awlen,
  output wire  [C_AXI_SIZE_WIDTH-1:0]      s_axi_awsize,
  input wire                               s_axi_awready,

  output wire  [C_AXI_ADDR_WIDTH-1:0]      s_axi_araddr,
  output wire                              s_axi_arvalid,
  output wire  [C_AXI_BRST_WIDTH-1:0]      s_axi_arburst,
  output wire  [C_AXI_ID_WIDTH-1:0]        s_axi_arid,
  output wire  [C_AXI_LEN_WIDTH-1:0]       s_axi_arlen,
  output wire  [C_AXI_SIZE_WIDTH-1:0]      s_axi_arsize,
  input wire                               s_axi_arready,

  output wire  [C_AXI_DATA_WIDTH-1:0]      s_axi_wdata,
  output wire  [C_AXI_WUSER_WIDTH-1:0]     s_axi_wuser,
  output wire  [C_AXI_STB_WIDTH-1:0]       s_axi_wstrb,
  input wire                               s_axi_wready,
  output wire                              s_axi_wlast,
  output wire                              s_axi_wvalid,

  input wire                               s_axi_bvalid,
  output wire                              s_axi_bready,
                                         
  output wire                              s_axi_rready,
  input wire                               s_axi_rvalid
);

  reg                              m_axi_arready_reg;
  reg                              m_axi_awready_reg;
  reg                              m_axi_wready_reg;
  reg                              m_axi_rlast_reg;
  reg                              m_axi_rvalid_reg;
  reg  [C_AXI_DATA_WIDTH-1:0]      m_axi_rdata_reg;
  reg  [C_AXI_ID_WIDTH-1:0]        m_axi_rid_reg;
  reg  [C_AXI_RESP_WIDTH-1:0]      m_axi_rresp_reg;
  reg                              m_axi_bvalid_reg;
  reg  [C_AXI_ID_WIDTH-1:0]        m_axi_bid_reg;
  reg  [C_AXI_RESP_WIDTH-1:0]      m_axi_bresp_reg;

  reg                              s_axi_awvalid_reg;
  reg  [C_AXI_ADDR_WIDTH-1:0]      s_axi_awaddr_reg;
  reg  [C_AXI_BRST_WIDTH-1:0]      s_axi_awburst_reg;
  reg  [C_AXI_ID_WIDTH-1:0]        s_axi_awid_reg;
  reg  [C_AXI_LEN_WIDTH-1:0]       s_axi_awlen_reg;
  reg  [C_AXI_SIZE_WIDTH-1:0]      s_axi_awsize_reg;
  reg  [C_AXI_ADDR_WIDTH-1:0]      s_axi_araddr_reg;
  reg                              s_axi_arvalid_reg;
  reg  [C_AXI_BRST_WIDTH-1:0]      s_axi_arburst_reg;
  reg  [C_AXI_ID_WIDTH-1:0]        s_axi_arid_reg;
  reg  [C_AXI_LEN_WIDTH-1:0]       s_axi_arlen_reg;
  reg  [C_AXI_SIZE_WIDTH-1:0]      s_axi_arsize_reg;
  reg  [C_AXI_DATA_WIDTH-1:0]      s_axi_wdata_reg;
  reg  [C_AXI_WUSER_WIDTH-1:0]     s_axi_wuser_reg;
  reg  [C_AXI_STB_WIDTH-1:0]       s_axi_wstrb_reg;
  reg                              s_axi_wlast_reg;
  reg                              s_axi_wvalid_reg;
  reg                              s_axi_bready_reg;
  reg                              s_axi_rready_reg;

generate if ( ( C_GEN_MAS_TRAFFIC == 1 ) & ( C_GEN_TRAFFIC_MAS_SLV == 0 ) ) 
begin: master_aw_ar_w_traffic_gen
    assign  s_axi_awvalid  =  s_axi_awvalid_reg;
    assign  s_axi_awaddr   =  s_axi_awaddr_reg;
    assign  s_axi_awburst  =  s_axi_awburst_reg;
    assign  s_axi_awsize[2]   =  1'b0;
    assign  s_axi_awsize[1:0] =  s_axi_awsize_reg[1:0];
    assign  s_axi_awlen    =  s_axi_awlen_reg;
    assign  s_axi_awid      =  s_axi_awid_reg;
                                                
    assign  s_axi_araddr   =  s_axi_araddr_reg;
    assign  s_axi_arvalid  =  s_axi_arvalid_reg;
    assign  s_axi_arburst  =  s_axi_arburst_reg;
    assign  s_axi_arsize[2]   =  1'b0;
    assign  s_axi_arsize[1:0] =  s_axi_arsize_reg[1:0];
    assign  s_axi_arlen    =  s_axi_arlen_reg;
    assign  s_axi_arid      =  s_axi_arid_reg;
                                                
    assign  s_axi_wdata    =  s_axi_wdata_reg;
    assign  s_axi_wuser    =  s_axi_wuser_reg;
    assign  s_axi_wstrb    =  s_axi_wstrb_reg;
    assign  s_axi_wlast    =  s_axi_wlast_reg;
    assign  s_axi_wvalid   =  s_axi_wvalid_reg;
                                                
    assign  s_axi_bready   =  s_axi_bready_reg;
    assign  s_axi_rready   =  s_axi_rready_reg;
   
    assign  m_axi_arready  =  1'b 0;
    assign  m_axi_awready  =  1'b 0;
    assign  m_axi_wready   =  1'b 0;
   
    assign  m_axi_rlast    =  1'b 0;
    assign  m_axi_rvalid   =  1'b 0;
    assign  m_axi_rdata    =  { C_AXI_DATA_WIDTH { 1'b 0 } };
    assign  m_axi_rid      =  { C_AXI_ID_WIDTH { 1'b 0 } };
    assign  m_axi_rresp    =  { C_AXI_RESP_WIDTH { 1'b 0 } };
                                        
    assign  m_axi_bvalid   =  1'b 0;
    assign  m_axi_bid      =  { C_AXI_ID_WIDTH { 1'b 0 } };
    assign  m_axi_bresp    =  { C_AXI_RESP_WIDTH { 1'b 0 } };
   
    always @ ( posedge s_axi_aclk )
    begin
       if ( s_axi_reset_n == 1'b 0 )
       begin
          s_axi_arvalid_reg    <= 0;
          s_axi_araddr_reg     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
          s_axi_arburst_reg    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
          s_axi_arid_reg       <= { C_AXI_ID_WIDTH { 1'b 0 } };
          s_axi_arlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
          s_axi_arsize_reg     <= { C_AXI_SIZE_WIDTH { 1'b 0 } };
       
          s_axi_awvalid_reg    <= 1'b 0;
          s_axi_awaddr_reg     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
          s_axi_awburst_reg    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
          s_axi_awid_reg       <= { C_AXI_ID_WIDTH { 1'b 0 } };
          s_axi_awlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
          s_axi_awsize_reg     <= { C_AXI_SIZE_WIDTH { 1'b 0 } };
       
          s_axi_wvalid_reg     <= 0;
          s_axi_wdata_reg      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
          s_axi_wuser_reg      <= { C_AXI_WUSER_WIDTH { 1'b 1 } };
          s_axi_wlast_reg      <= 1'b 1;
          s_axi_wstrb_reg      <= { C_AXI_STB_WIDTH { 1'b 1 } };
       
          s_axi_bready_reg     <= 1'b 0;
          s_axi_rready_reg     <= 1'b 0;
       end
       else
       begin
          s_axi_bready_reg     <= s_axi_bvalid;
          s_axi_rready_reg     <= s_axi_rvalid;
       
          s_axi_arvalid_reg    <= s_axi_arready & ~s_axi_arvalid;
          if ( s_axi_arvalid & s_axi_arready )
          begin
             s_axi_araddr_reg     <= s_axi_araddr  + 4'd 1;
             s_axi_arburst_reg    <= 4'd 2;
             s_axi_arid_reg       <= s_axi_arid    + 4'd 3;
          s_axi_arlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 }} + 1'b 1 ;
             s_axi_arsize_reg     <= 4'd 2;
         end
       
          s_axi_awvalid_reg    <= s_axi_awready & ~s_axi_awvalid;
          if ( s_axi_awvalid & s_axi_awready )
          begin
             s_axi_awaddr_reg     <= s_axi_awaddr  - 4'd 1;
             s_axi_awburst_reg    <= 4'd 2;
             s_axi_awid_reg       <= s_axi_awid    - 4'd 3;
             s_axi_awlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             s_axi_awsize_reg     <= 4'd 2;
 
         end
       
          s_axi_wvalid_reg    <= s_axi_wready ;//& ~s_axi_wvalid;
          if ( s_axi_wvalid & s_axi_wready )
          begin
             s_axi_wdata_reg      <= s_axi_wdata  - 1'd 1;
             s_axi_wuser_reg      <= s_axi_wuser  - 2'd 2;
             s_axi_wlast_reg      <= ~s_axi_wlast;
             s_axi_wstrb_reg      <= { C_AXI_STB_WIDTH { 1'b 1 } };
          end
       end
    end
end
else if ( ( C_GEN_MAS_TRAFFIC == 0 ) & ( C_GEN_TRAFFIC_MAS_SLV == 0 ) ) 
begin: slave_aw_ar_w_traffic_gen
		
    assign  m_axi_rlast    =  m_axi_rlast_reg;   
    assign  m_axi_rvalid   =  m_axi_rvalid_reg;
    assign  m_axi_rdata    =  m_axi_rdata_reg;
    assign  m_axi_rid      =  m_axi_rid_reg;
    assign  m_axi_rresp    =  m_axi_rresp_reg;
                              
    assign  m_axi_bvalid   =  m_axi_bvalid_reg;
    assign  m_axi_bid      =  m_axi_bid_reg;
    assign  m_axi_bresp    =  m_axi_bresp_reg;
                                                
    assign  m_axi_arready     =  m_axi_arready_reg;
    assign  m_axi_awready     =  m_axi_awready_reg;
    assign  m_axi_wready      =  m_axi_wready_reg;

    assign  s_axi_awvalid  = 1'b 0;                           
    assign  s_axi_awaddr  = { C_AXI_ADDR_WIDTH { 1'b 0 } };      
    assign  s_axi_awburst = { C_AXI_BRST_WIDTH { 1'b 0 } };      
    assign  s_axi_awid    = { C_AXI_ID_WIDTH { 1'b 0 } };        
    assign  s_axi_awlen   = { C_AXI_LEN_WIDTH { 1'b 0 } };       
    assign  s_axi_awsize  = { C_AXI_SIZE_WIDTH { 1'b 0 } };      
    assign  s_axi_araddr  = { C_AXI_ADDR_WIDTH { 1'b 0 } };      
    assign  s_axi_arvalid   = 1'b 0;                          
    assign  s_axi_arburst = { C_AXI_BRST_WIDTH { 1'b 0 } };      
    assign  s_axi_arid    = { C_AXI_ID_WIDTH { 1'b 0 } };        
    assign  s_axi_arlen   = { C_AXI_LEN_WIDTH { 1'b 0 } };       
    assign  s_axi_arsize  = { C_AXI_SIZE_WIDTH { 1'b 0 } };      
    assign  s_axi_wdata   = { C_AXI_DATA_WIDTH { 1'b 0 } };      
    assign  s_axi_wuser   = { C_AXI_WUSER_WIDTH { 1'b 0 } };     
    assign  s_axi_wstrb   = { C_AXI_STB_WIDTH { 1'b 0 } };       
    assign  s_axi_wlast      = 1'b 0;                         
    assign  s_axi_wvalid      = 1'b 0;                        
    assign  s_axi_bready      = 1'b 0;                        
    assign  s_axi_rready       = 1'b 0;                       

    always @ ( posedge m_axi_aclk )
    begin
        if ( m_axi_reset_n == 1'b 0 )
        begin
          m_axi_arready_reg    <= 1'b 0;
          m_axi_awready_reg    <= 1'b 0;
          m_axi_wready_reg     <= 1'b 0;
    
          m_axi_bvalid_reg     <= 1'b 0;
          m_axi_bid_reg        <= { C_AXI_ID_WIDTH { 1'b 0 } };
          m_axi_bresp_reg      <= { C_AXI_RESP_WIDTH { 1'b 1 } };
    
          m_axi_rvalid_reg     <= 1'b 0;
          m_axi_rdata_reg      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
          m_axi_rid_reg        <= { C_AXI_ID_WIDTH { 1'b 1 } };
          m_axi_rlast_reg      <= 1'b 0;
          m_axi_rresp_reg      <= { C_AXI_RESP_WIDTH { 1'b 0 } };
        end
        else
        begin
          m_axi_arready_reg    <= m_axi_arvalid & ~m_axi_arready_reg;
          m_axi_awready_reg    <= m_axi_awvalid & ~m_axi_awready_reg;
          m_axi_wready_reg     <= m_axi_wvalid;// & ~m_axi_wready;
     
          m_axi_bvalid_reg     <= m_axi_bready & ~m_axi_bvalid_reg;
          m_axi_rvalid_reg     <= m_axi_rready & ~m_axi_rvalid_reg;
     
          if ( m_axi_bvalid_reg & m_axi_bready )
          begin
            m_axi_bid_reg        <= m_axi_bid_reg   + 1'b 1;
            m_axi_bresp_reg      <= m_axi_bresp_reg - 1'b 1;
          end
     
          if ( m_axi_rvalid_reg & m_axi_rready )
          begin
            m_axi_rdata_reg      <= m_axi_rdata_reg + 2'd 3;
            m_axi_rid_reg        <= m_axi_rid_reg   + 2'd 2;
            m_axi_rlast_reg      <= ~m_axi_rlast_reg;
            m_axi_rresp_reg      <= m_axi_rresp_reg + 1'd 1;
          end
        end
    end
end
else
begin

    assign  s_axi_awvalid  =  s_axi_awvalid_reg;
    assign  s_axi_awaddr   =  s_axi_awaddr_reg;
    assign  s_axi_awburst  =  s_axi_awburst_reg;
    assign  s_axi_awsize[2]   =  1'b0;
    assign  s_axi_awsize[1:0] =  s_axi_awsize_reg[1:0];
    assign  s_axi_awlen    =  s_axi_awlen_reg;
    assign  s_axi_awid      =  s_axi_awid_reg;
                                                
    assign  s_axi_araddr   =  s_axi_araddr_reg;
    assign  s_axi_arvalid  =  s_axi_arvalid_reg;
    assign  s_axi_arburst  =  s_axi_arburst_reg;
    assign  s_axi_arsize[2]   =  1'b0;
    assign  s_axi_arsize[1:0] =  s_axi_arsize_reg[1:0];
    assign  s_axi_arlen    =  s_axi_arlen_reg;
    assign  s_axi_arid      =  s_axi_arid_reg;
                                                
    assign  s_axi_wdata    =  s_axi_wdata_reg;
    assign  s_axi_wuser    =  s_axi_wuser_reg;
    assign  s_axi_wstrb    =  s_axi_wstrb_reg;
    assign  s_axi_wlast    =  s_axi_wlast_reg;
    assign  s_axi_wvalid   =  s_axi_wvalid_reg;
                                                
    assign  s_axi_bready   =  s_axi_bready_reg;
    assign  s_axi_rready   =  s_axi_rready_reg;
   
    always @ ( posedge s_axi_aclk )
    begin
       if ( s_axi_reset_n == 1'b 0 )
       begin
          s_axi_arvalid_reg    <= 0;
          s_axi_araddr_reg     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
          s_axi_arburst_reg    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
          s_axi_arid_reg       <= { C_AXI_ID_WIDTH { 1'b 0 } };
          s_axi_arlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
          s_axi_arsize_reg     <= { C_AXI_SIZE_WIDTH { 1'b 0 } };
       
          s_axi_awvalid_reg    <= 1'b 0;
          s_axi_awaddr_reg     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
          s_axi_awburst_reg    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
          s_axi_awid_reg       <= { C_AXI_ID_WIDTH { 1'b 0 } };
          s_axi_awlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
          s_axi_awsize_reg     <= { C_AXI_SIZE_WIDTH { 1'b 0 } };
       
          s_axi_wvalid_reg     <= 0;
          s_axi_wdata_reg      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
          s_axi_wuser_reg      <= { C_AXI_WUSER_WIDTH { 1'b 1 } };
          s_axi_wlast_reg      <= 1'b 1;
          s_axi_wstrb_reg      <= { C_AXI_STB_WIDTH { 1'b 1 } };
       
          s_axi_bready_reg     <= 1'b 0;
          s_axi_rready_reg     <= 1'b 0;
       end
       else
       begin
          s_axi_bready_reg     <= s_axi_bvalid;
          s_axi_rready_reg     <= s_axi_rvalid;
       
          s_axi_arvalid_reg    <= s_axi_arready & ~s_axi_arvalid;
          if ( s_axi_arvalid & s_axi_arready )
          begin
             s_axi_araddr_reg     <= s_axi_araddr  + 4'd 1;
             s_axi_arburst_reg    <= 4'd 2;
             s_axi_arid_reg       <= s_axi_arid    + 4'd 3;
             s_axi_arlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             s_axi_arsize_reg     <= 4'd 2;
   
       end
       
          s_axi_awvalid_reg    <= s_axi_awready & ~s_axi_awvalid;
          if ( s_axi_awvalid & s_axi_awready )
          begin
             s_axi_awaddr_reg     <= s_axi_awaddr  - 4'd 1;
             s_axi_awburst_reg    <= 4'd 2;
             s_axi_awid_reg       <= s_axi_awid    - 4'd 3;
             s_axi_awlen_reg      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             s_axi_awsize_reg     <= 4'd 2;
          end
       
          s_axi_wvalid_reg    <= s_axi_wready ;
          if ( s_axi_wvalid & s_axi_wready )
          begin
             s_axi_wdata_reg      <= s_axi_wdata  - 1'd 1;
             s_axi_wuser_reg      <= s_axi_wuser  - 2'd 2;
             s_axi_wlast_reg      <= ~s_axi_wlast;
             s_axi_wstrb_reg      <= { C_AXI_STB_WIDTH { 1'b 1 } };
          end
       end
    end

    assign  m_axi_rlast    =  m_axi_rlast_reg;   
    assign  m_axi_rvalid   =  m_axi_rvalid_reg;
    assign  m_axi_rdata    =  m_axi_rdata_reg;
    assign  m_axi_rid      =  m_axi_rid_reg;
    assign  m_axi_rresp    =  m_axi_rresp_reg;
                              
    assign  m_axi_bvalid   =  m_axi_bvalid_reg;
    assign  m_axi_bid      =  m_axi_bid_reg;
    assign  m_axi_bresp    =  m_axi_bresp_reg;
                                                
    assign  m_axi_arready     =  m_axi_arready_reg;
    assign  m_axi_awready     =  m_axi_awready_reg;
    assign  m_axi_wready      =  m_axi_wready_reg;

    always @ ( posedge m_axi_aclk )
    begin
        if ( m_axi_reset_n == 1'b 0 )
        begin
          m_axi_arready_reg    <= 1'b 0;
          m_axi_awready_reg    <= 1'b 0;
          m_axi_wready_reg     <= 1'b 0;
    
          m_axi_bvalid_reg     <= 1'b 0;
          m_axi_bid_reg        <= { C_AXI_ID_WIDTH { 1'b 0 } };
          m_axi_bresp_reg      <= { C_AXI_RESP_WIDTH { 1'b 1 } };
    
          m_axi_rvalid_reg     <= 1'b 0;
          m_axi_rdata_reg      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
          m_axi_rid_reg        <= { C_AXI_ID_WIDTH { 1'b 1 } };
          m_axi_rlast_reg      <= 1'b 0;
          m_axi_rresp_reg      <= { C_AXI_RESP_WIDTH { 1'b 0 } };
        end
        else
        begin
          m_axi_arready_reg    <= m_axi_arvalid & ~m_axi_arready_reg;
          m_axi_awready_reg    <= m_axi_awvalid & ~m_axi_awready_reg;
          m_axi_wready_reg     <= m_axi_wvalid;// & ~m_axi_wready;
     
          m_axi_bvalid_reg     <= m_axi_bready & ~m_axi_bvalid_reg;
          m_axi_rvalid_reg     <= m_axi_rready & ~m_axi_rvalid_reg;
     
          if ( m_axi_bvalid_reg & m_axi_bready )
          begin
            m_axi_bid_reg        <= m_axi_bid_reg   + 1'b 1;
            m_axi_bresp_reg      <= m_axi_bresp_reg - 1'b 1;
          end
     
          if ( m_axi_rvalid_reg & m_axi_rready )
          begin
            m_axi_rdata_reg      <= m_axi_rdata_reg + 2'd 3;
            m_axi_rid_reg        <= m_axi_rid_reg   + 2'd 2;
            m_axi_rlast_reg      <= ~m_axi_rlast_reg;
            m_axi_rresp_reg      <= m_axi_rresp_reg + 1'd 1;
          end
        end
    end
end
endgenerate
 
endmodule
