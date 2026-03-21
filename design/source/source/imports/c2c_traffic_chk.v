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
module traffic_chk
#(
parameter   C_CHK_MAS_TRAFFIC   = 0,
parameter   C_CHK_TRAFFIC_MAS_SLV = 0,
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
  input wire                              s_axi_aclk,
  input wire                              s_axi_reset_n,
  input wire                              m_axi_aclk,
  input wire                              m_axi_reset_n,

  input wire                              m_axi_awvalid,
  input wire  [C_AXI_ADDR_WIDTH-1:0]      m_axi_awaddr,
  input wire  [C_AXI_BRST_WIDTH-1:0]      m_axi_awburst,
  input wire  [C_AXI_ID_WIDTH-1:0]        m_axi_awid,
  input wire  [C_AXI_LEN_WIDTH-1:0]       m_axi_awlen,
  input wire  [C_AXI_SIZE_WIDTH-1:0]      m_axi_awsize,
  input wire                              m_axi_awready,

  input wire  [C_AXI_ADDR_WIDTH-1:0]      m_axi_araddr,
  input wire                              m_axi_arvalid,
  input wire  [C_AXI_BRST_WIDTH-1:0]      m_axi_arburst,
  input wire  [C_AXI_ID_WIDTH-1:0]        m_axi_arid,
  input wire  [C_AXI_LEN_WIDTH-1:0]       m_axi_arlen,
  input wire  [C_AXI_SIZE_WIDTH-1:0]      m_axi_arsize,
  input wire                              m_axi_arready,

  input wire  [C_AXI_DATA_WIDTH-1:0]      m_axi_wdata,
  input wire  [C_AXI_WUSER_WIDTH-1:0]     m_axi_wuser,
  input wire  [C_AXI_STB_WIDTH-1:0]       m_axi_wstrb,
  input wire                              m_axi_wready,
  input wire                              m_axi_wlast,
  input wire                              m_axi_wvalid,

  input wire                              s_axi_bvalid,
  input wire                              s_axi_bready,
  input wire                              s_axi_rready,
  input wire                              s_axi_rvalid,

  input wire  [C_AXI_ID_WIDTH-1:0]        s_axi_bid,
  input wire  [C_AXI_RESP_WIDTH-1:0]      s_axi_bresp,

  input wire                              s_axi_rlast,
  input wire  [C_AXI_DATA_WIDTH-1:0]      s_axi_rdata,
  input wire  [C_AXI_ID_WIDTH-1:0]        s_axi_rid,
  input wire  [C_AXI_RESP_WIDTH-1:0]      s_axi_rresp,

  output   wire                            aw_error,
  output   wire                            ar_error,
  output   wire                            w_error,
  output   wire                            r_error,
  output   wire                            b_error
);

   reg      aw_error_reg;
   reg      ar_error_reg;
   reg      w_error_reg;
   reg      r_error_reg;
   reg      b_error_reg;


localparam C_AXI_SIZE_WIDTH_i = ( C_AXI_DATA_WIDTH == 32 ) ? 2 : ( ( C_AXI_DATA_WIDTH == 64 ) ? 2 : 3 );

 wire  [2-1:0]    m_axi_arsize_i;
 wire  [2-1:0]    m_axi_awsize_i;
 assign m_axi_arsize_i  = m_axi_arsize[1:0];
 assign m_axi_awsize_i  = m_axi_awsize[1:0];

  reg  [C_AXI_ADDR_WIDTH-1:0]      exp_axi_araddr;
  reg  [C_AXI_BRST_WIDTH-1:0]      exp_axi_arburst;
  reg  [C_AXI_ID_WIDTH-1:0]        exp_axi_arid;
  reg  [C_AXI_LEN_WIDTH-1:0]       exp_axi_arlen;
  reg  [C_AXI_SIZE_WIDTH_i-1:0]      exp_axi_arsize;
  reg  [C_AXI_ADDR_WIDTH-1:0]      exp_axi_awaddr;
  reg  [C_AXI_BRST_WIDTH-1:0]      exp_axi_awburst;
  reg  [C_AXI_ID_WIDTH-1:0]        exp_axi_awid;
  reg  [C_AXI_LEN_WIDTH-1:0]       exp_axi_awlen;
  reg  [C_AXI_SIZE_WIDTH_i-1:0]      exp_axi_awsize;
  reg                              exp_axi_wlast;
  reg  [C_AXI_DATA_WIDTH-1:0]      exp_axi_wdata;
  reg  [C_AXI_WUSER_WIDTH-1:0]     exp_axi_wuser;
  reg  [C_AXI_STB_WIDTH-1:0]       exp_axi_wstrb;
  reg                              exp_axi_rlast;
  reg  [C_AXI_DATA_WIDTH-1:0]      exp_axi_rdata;
  reg  [C_AXI_ID_WIDTH-1:0]        exp_axi_rid;
  reg  [C_AXI_RESP_WIDTH-1:0]      exp_axi_rresp;
  reg  [C_AXI_ID_WIDTH-1:0]        exp_axi_bid;
  reg  [C_AXI_RESP_WIDTH-1:0]      exp_axi_bresp;


generate if ( ( C_CHK_MAS_TRAFFIC == 0 ) & ( C_CHK_TRAFFIC_MAS_SLV == 0 ) ) 
begin: slave_aw_ar_w_traffic_chk

  assign    aw_error     =     aw_error_reg;
  assign    ar_error     =     ar_error_reg;
  assign    w_error      =     w_error_reg;
  assign    r_error      =      1'b 0;
  assign    b_error      =      1'b 0;
  always @ ( posedge m_axi_aclk or negedge m_axi_reset_n)
  begin
     if ( m_axi_reset_n == 1'b 0 )
     begin
        exp_axi_araddr     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
        exp_axi_arburst    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
        exp_axi_arid       <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_arlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
        exp_axi_arsize     <= { C_AXI_SIZE_WIDTH_i { 1'b 0 } };
        exp_axi_awaddr     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
        exp_axi_awburst    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
        exp_axi_awid       <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_awlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
        exp_axi_awsize     <= { C_AXI_SIZE_WIDTH_i { 1'b 0 } };
        exp_axi_wdata      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
        exp_axi_wuser      <= { C_AXI_WUSER_WIDTH { 1'b 1 } };
        exp_axi_wlast      <= 1'b 1;
        exp_axi_wstrb      <= { C_AXI_STB_WIDTH { 1'b 1 } };
        aw_error_reg       <= 1'b 0;
        ar_error_reg       <= 1'b 0;
        w_error_reg        <= 1'b 0;
        r_error_reg        <= 1'b 0;
        b_error_reg        <= 1'b 0;
     end
     else
     begin
        if ( m_axi_arvalid & m_axi_arready )
        begin
             exp_axi_araddr     <= exp_axi_araddr  + 4'd 1;
             exp_axi_arburst    <= 4'd 2;
             exp_axi_arid       <= exp_axi_arid    + 4'd 3;
             exp_axi_arlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             exp_axi_arsize     <= 4'd 2;
            
  	     if ( ( exp_axi_araddr != m_axi_araddr ) | ( exp_axi_arburst != m_axi_arburst ) |
  	          ( exp_axi_arid   != m_axi_arid   ) | ( exp_axi_arlen   != m_axi_arlen   ) |
  	          ( exp_axi_arsize != m_axi_arsize ) )
             begin
  	        ar_error_reg <= 1'b 1;
  	     end
  	     // synthesis translate_off
             if ( ( exp_axi_araddr !== m_axi_araddr ) | ( exp_axi_arburst !== m_axi_arburst ) |
                  ( exp_axi_arid   !== m_axi_arid   ) | ( exp_axi_arlen   !== m_axi_arlen   ) |
                  ( exp_axi_arsize !== m_axi_arsize ) )
             begin
                $display ( "ERROR :: AR Mismatch exp_axi_araddr = %h, exp_axi_arburst = %h, exp_axi_arid = %h, exp_axi_arlen = %h, exp_axi_arsize = %h",
                            exp_axi_araddr , exp_axi_arburst , exp_axi_arid , exp_axi_arlen , exp_axi_arsize);
	        $display ( "ERROR :: AR Mismatch   m_axi_araddr = %h,   m_axi_arburst = %h,   m_axi_arid = %h, m_axi_arlen = %h,   m_axi_arsize = %h",
	                    m_axi_araddr , m_axi_arburst , m_axi_arid , m_axi_arlen , m_axi_arsize);
	        $stop;
	     end
             else
             begin
                $display ( "AR Match exp_axi_araddr = %h, exp_axi_arburst = %h, exp_axi_arid = %h, exp_axi_arlen = %h, exp_axi_arsize = %h",
                            exp_axi_araddr , exp_axi_arburst , exp_axi_arid , exp_axi_arlen , exp_axi_arsize);
                $display ( "AR Match   m_axi_araddr = %h,   m_axi_arburst = %h,   m_axi_arid = %h, m_axi_arlen = %h,   m_axi_arsize = %h ",
                            m_axi_araddr , m_axi_arburst , m_axi_arid , m_axi_arlen , m_axi_arsize);
             end
             // synthesis translate_on
        end

        if ( m_axi_awvalid & m_axi_awready )
        begin
           exp_axi_awaddr     <= exp_axi_awaddr  - 4'd 1;
           exp_axi_awburst    <= 4'd 2;
           exp_axi_awid       <= exp_axi_awid    - 4'd 3;
           exp_axi_awlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             exp_axi_awsize     <= 4'd 2;
  
           if ( ( exp_axi_awaddr != m_axi_awaddr ) | ( exp_axi_awburst != m_axi_awburst ) |
                ( exp_axi_awid   != m_axi_awid   ) | ( exp_axi_awlen   != m_axi_awlen   ) |
                ( exp_axi_awsize != m_axi_awsize ) )
           begin
              aw_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_awaddr !== m_axi_awaddr ) | ( exp_axi_awburst !== m_axi_awburst ) |
                ( exp_axi_awid   !== m_axi_awid   ) | ( exp_axi_awlen   !== m_axi_awlen   ) |
                ( exp_axi_awsize !== m_axi_awsize ) )
           begin
             $display ( "ERROR :: AW Mismatch exp_axi_awaddr = %h, exp_axi_awburst = %h, exp_axi_awid = %h, exp_axi_awlen = %h, exp_axi_awsize = %h",
                         exp_axi_awaddr , exp_axi_awburst , exp_axi_awid , exp_axi_awlen , exp_axi_awsize );
             $display ( "ERROR :: AW Mismatch   m_axi_awaddr = %h,   m_axi_awburst = %h,   m_axi_awid = %h, m_axi_awlen = %h,   m_axi_awsize = %h",
                         m_axi_awaddr , m_axi_awburst , m_axi_awid , m_axi_awlen , m_axi_awsize );
             $stop;
           end
           else
           begin
             $display ( "AW Match exp_axi_awaddr = %h, exp_axi_awburst = %h, exp_axi_awid = %h,exp_axi_awlen = %h, exp_axi_awsize = %h",
                         exp_axi_awaddr , exp_axi_awburst , exp_axi_awid , exp_axi_awlen , exp_axi_awsize );
             $display ( "AW Match   m_axi_awaddr = %h,   m_axi_awburst = %h,   m_axi_awid = %h, m_axi_awlen = %h,   m_axi_awsize = %h ",
                        m_axi_awaddr , m_axi_awburst , m_axi_awid , m_axi_awlen , m_axi_awsize );
           end

           // synthesis translate_on
        end
  
        if ( m_axi_wvalid & m_axi_wready )
        begin
           exp_axi_wdata      <= exp_axi_wdata  - 1'd 1;
           exp_axi_wuser      <= exp_axi_wuser  - 2'd 2;
           exp_axi_wlast      <= ~exp_axi_wlast;
        exp_axi_wstrb      <= { C_AXI_STB_WIDTH { 1'b 1 } };
           if ( ( exp_axi_wdata != m_axi_wdata ) | ( exp_axi_wuser != m_axi_wuser ) |
                ( exp_axi_wlast != m_axi_wlast ) | ( exp_axi_wstrb != m_axi_wstrb ) )
           begin
              w_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_wdata !== m_axi_wdata ) | ( exp_axi_wuser !== m_axi_wuser ) |
                ( exp_axi_wlast !== m_axi_wlast ) | ( exp_axi_wstrb !== m_axi_wstrb ) )
           begin
              $display ( " ERROR :: W Mismatch exp_axi_wdata = %h, exp_axi_wuser   = %h, exp_axi_wlast = %h, exp_axi_wstrb = %h",
                           exp_axi_wdata , exp_axi_wuser   , exp_axi_wlast , exp_axi_wstrb );
              $display ( " ERROR :: W Mismatch   m_axi_wdata = %h,   m_axi_wuser   = %h,   m_axi_wlast = %h,   m_axi_wstrb = %h",
                           m_axi_wdata , m_axi_wuser   , m_axi_wlast , m_axi_wstrb );
              $stop;
           end
           else
           begin
              $display ( " W Match exp_axi_wdata = %h, exp_axi_wuser   = %h, exp_axi_wlast = %h, exp_axi_wstrb = %h",
                           exp_axi_wdata , exp_axi_wuser   , exp_axi_wlast , exp_axi_wstrb );
              $display ( " W Match   m_axi_wdata = %h,   m_axi_wuser   = %h,   m_axi_wlast = %h,   m_axi_wstrb = %h",
                           m_axi_wdata , m_axi_wuser   , m_axi_wlast , m_axi_wstrb );
           end
           // synthesis translate_on
        end
     end
  end
end
else if ( ( C_CHK_MAS_TRAFFIC == 1 ) & ( C_CHK_TRAFFIC_MAS_SLV == 0 ) ) 
begin: master_aw_ar_w_traffic_chk
  
  assign    r_error      =     r_error_reg;
  assign    b_error      =     b_error_reg;
  assign    aw_error     =       1'b 0;
  assign    ar_error     =       1'b 0;
  assign    w_error      =       1'b 0;
  always @ ( posedge s_axi_aclk or negedge s_axi_reset_n)
  begin
     if ( s_axi_reset_n == 1'b 0 )
     begin
        exp_axi_bid      <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_bresp    <= { C_AXI_RESP_WIDTH { 1'b 1 } };
  
        exp_axi_rdata    <= { C_AXI_DATA_WIDTH { 1'b 1 } };
        exp_axi_rid      <= { C_AXI_ID_WIDTH { 1'b 1 } };
        exp_axi_rlast    <= 1'b 0;
        exp_axi_rresp    <= { C_AXI_RESP_WIDTH { 1'b 0 } };
  
        r_error_reg          <= 1'b 0;
        b_error_reg          <= 1'b 0;
        aw_error_reg         <= 1'b 0;
        ar_error_reg         <= 1'b 0;
        w_error_reg          <= 1'b 0;
     end
     else
     begin
        if ( s_axi_bvalid & s_axi_bready )
        begin
           exp_axi_bid        <= exp_axi_bid   + 1'b 1;
           exp_axi_bresp      <= exp_axi_bresp - 1'b 1;
           if ( ( exp_axi_bid != s_axi_bid ) | ( exp_axi_bresp != s_axi_bresp ))
           begin
              b_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_bid !== s_axi_bid ) | ( exp_axi_bresp !== s_axi_bresp ) )
           begin
              $display ( "ERROR :: B Mismatch exp_axi_bid   = %h, exp_axi_bresp = %h", exp_axi_bid , exp_axi_bresp);
              $display ( "ERROR :: B Mismatch   s_axi_bid   = %h,   s_axi_bresp = %h", s_axi_bid , s_axi_bresp);
              $stop;
           end
           else
           begin
              $display ( "B Match exp_axi_bid   = %h, exp_axi_bresp = %h", exp_axi_bid , exp_axi_bresp);
              $display ( "B Match   s_axi_bid   = %h,   s_axi_bresp = %h", s_axi_bid , s_axi_bresp);
           end
           // synthesis translate_on
        end
        if ( s_axi_rvalid & s_axi_rready )
        begin
           exp_axi_rdata      <= exp_axi_rdata + 2'd 3;
           exp_axi_rid        <= exp_axi_rid   + 2'd 2;
           exp_axi_rlast      <= ~exp_axi_rlast;
           exp_axi_rresp      <= exp_axi_rresp + 1'd 1;
           if ( ( exp_axi_rdata    != s_axi_rdata ) | ( exp_axi_rid      != s_axi_rid   ) |
                ( exp_axi_rlast    != s_axi_rlast ) | ( exp_axi_rresp    != s_axi_rresp ) )
           begin
              r_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_rdata    !== s_axi_rdata ) | ( exp_axi_rid      !== s_axi_rid   ) |
                ( exp_axi_rlast    !== s_axi_rlast ) | ( exp_axi_rresp    !== s_axi_rresp ) )
           begin
              $display ( "ERROR :: R Mismatch exp_axi_rdata  = %h, exp_axi_rid    = %h, exp_axi_rlast  = %h, exp_axi_rresp  = %h",
                          exp_axi_rdata  , exp_axi_rid    , exp_axi_rlast  , exp_axi_rresp );
              $display ( "ERROR :: R Mismatch   s_axi_rdata  = %h,   s_axi_rid    = %h,   s_axi_rlast  = %h,   s_axi_rresp  = %h",
                          s_axi_rdata  , s_axi_rid    , s_axi_rlast  , s_axi_rresp );
              $stop;
           end
           else
           begin
              $display ( "R Match exp_axi_rdata  = %h, exp_axi_rid    = %h, exp_axi_rlast  = %h, exp_axi_rresp  = %h",
                          exp_axi_rdata  , exp_axi_rid    , exp_axi_rlast  , exp_axi_rresp );
              $display ( "R Match   s_axi_rdata  = %h,   s_axi_rid    = %h,   s_axi_rlast  = %h,   s_axi_rresp  = %h",
                          s_axi_rdata  , s_axi_rid    , s_axi_rlast  , s_axi_rresp );
           end
           // synthesis translate_on
        end
     end
  end
end
else
begin
  assign    aw_error     =     aw_error_reg;
  assign    ar_error     =     ar_error_reg;
  assign    w_error      =     w_error_reg;
  assign    r_error      =     r_error_reg;
  assign    b_error      =     b_error_reg;

  always @ ( posedge m_axi_aclk or negedge m_axi_reset_n)
  begin
     if ( m_axi_reset_n == 1'b 0 )
     begin
        exp_axi_araddr     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
        exp_axi_arburst    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
        exp_axi_arid       <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_arlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
        exp_axi_arsize     <= { C_AXI_SIZE_WIDTH_i { 1'b 0 } };
        exp_axi_awaddr     <= { C_AXI_ADDR_WIDTH { 1'b 0 } };
        exp_axi_awburst    <= { C_AXI_BRST_WIDTH { 1'b 0 } };
        exp_axi_awid       <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_awlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } };
        exp_axi_awsize     <= { C_AXI_SIZE_WIDTH_i { 1'b 0 } };
        exp_axi_wdata      <= { C_AXI_DATA_WIDTH { 1'b 1 } };
        exp_axi_wuser      <= { C_AXI_WUSER_WIDTH { 1'b 1 } };
        exp_axi_wlast      <= 1'b 1;
        exp_axi_wstrb      <= { C_AXI_STB_WIDTH { 1'b 1 } };
        aw_error_reg           <= 1'b 0;
        ar_error_reg           <= 1'b 0;
        w_error_reg            <= 1'b 0;
     end
     else
     begin
        if ( m_axi_arvalid & m_axi_arready )
        begin
             exp_axi_araddr     <= exp_axi_araddr  + 4'd 1;
             exp_axi_arburst    <= 4'd 2;
             exp_axi_arid       <= exp_axi_arid    + 4'd 3;
             exp_axi_arlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             exp_axi_arsize     <= 4'd 2;
        
  	     if ( ( exp_axi_araddr != m_axi_araddr ) | ( exp_axi_arburst != m_axi_arburst ) |
  	          ( exp_axi_arid   != m_axi_arid   ) | ( exp_axi_arlen   != m_axi_arlen   ) |
  	          ( exp_axi_arsize != m_axi_arsize ) )
             begin
  	        ar_error_reg <= 1'b 1;
  	     end
  	     // synthesis translate_off
             if ( ( exp_axi_araddr !== m_axi_araddr ) | ( exp_axi_arburst !== m_axi_arburst ) |
                  ( exp_axi_arid   !== m_axi_arid   ) | ( exp_axi_arlen   !== m_axi_arlen   ) |
                  ( exp_axi_arsize !== m_axi_arsize ) )
             begin
                $display ( "ERROR :: AR Mismatch exp_axi_araddr = %h, exp_axi_arburst = %h, exp_axi_arid = %h, exp_axi_arlen = %h, exp_axi_arsize = %h",
                            exp_axi_araddr , exp_axi_arburst , exp_axi_arid , exp_axi_arlen , exp_axi_arsize);
	        $display ( "ERROR :: AR Mismatch   m_axi_araddr = %h,   m_axi_arburst = %h,   m_axi_arid = %h, m_axi_arlen = %h,   m_axi_arsize = %h",
	                    m_axi_araddr , m_axi_arburst , m_axi_arid , m_axi_arlen , m_axi_arsize);
	        $stop;
	     end
             else
             begin
                $display ( "AR Match exp_axi_araddr = %h, exp_axi_arburst = %h, exp_axi_arid = %h, exp_axi_arlen = %h, exp_axi_arsize = %h",
                            exp_axi_araddr , exp_axi_arburst , exp_axi_arid , exp_axi_arlen , exp_axi_arsize);
                $display ( "AR Match   m_axi_araddr = %h,   m_axi_arburst = %h,   m_axi_arid = %h, m_axi_arlen = %h,   m_axi_arsize = %h ",
                            m_axi_araddr , m_axi_arburst , m_axi_arid , m_axi_arlen , m_axi_arsize);
             end
             // synthesis translate_on
        end

        if ( m_axi_awvalid & m_axi_awready )
        begin
           exp_axi_awaddr     <= exp_axi_awaddr  - 4'd 1;
           exp_axi_awburst    <= exp_axi_awburst - 4'd 2;
           exp_axi_awid       <= exp_axi_awid    - 4'd 3;
             exp_axi_awlen      <= { C_AXI_LEN_WIDTH { 1'b 0 } } + 1'b 1 ;
             exp_axi_awsize     <= 4'd 2;
 
           if ( ( exp_axi_awaddr != m_axi_awaddr ) | ( exp_axi_awburst != m_axi_awburst ) |
                ( exp_axi_awid   != m_axi_awid   ) | ( exp_axi_awlen   != m_axi_awlen   ) |
                ( exp_axi_awsize != m_axi_awsize ) )
           begin
              aw_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_awaddr !== m_axi_awaddr ) | ( exp_axi_awburst !== m_axi_awburst ) |
                ( exp_axi_awid   !== m_axi_awid   ) | ( exp_axi_awlen   !== m_axi_awlen   ) |
                ( exp_axi_awsize !== m_axi_awsize ) )
           begin
             $display ( "ERROR :: AW Mismatch exp_axi_awaddr = %h, exp_axi_awburst = %h, exp_axi_awid = %h, exp_axi_awlen = %h, exp_axi_awsize = %h",
                         exp_axi_awaddr , exp_axi_awburst , exp_axi_awid , exp_axi_awlen , exp_axi_awsize );
             $display ( "ERROR :: AW Mismatch   m_axi_awaddr = %h,   m_axi_awburst = %h,   m_axi_awid = %h, m_axi_awlen = %h,   m_axi_awsize = %h",
                         m_axi_awaddr , m_axi_awburst , m_axi_awid , m_axi_awlen , m_axi_awsize );
             $stop;
           end
           else
           begin
             $display ( "AW Match exp_axi_awaddr = %h, exp_axi_awburst = %h, exp_axi_awid = %h,exp_axi_awlen = %h, exp_axi_awsize = %h",
                         exp_axi_awaddr , exp_axi_awburst , exp_axi_awid , exp_axi_awlen , exp_axi_awsize );
             $display ( "AW Match   m_axi_awaddr = %h,   m_axi_awburst = %h,   m_axi_awid = %h, m_axi_awlen = %h,   m_axi_awsize = %h ",
                        m_axi_awaddr , m_axi_awburst , m_axi_awid , m_axi_awlen , m_axi_awsize );
           end
           // synthesis translate_on
        end
  
        if ( m_axi_wvalid & m_axi_wready )
        begin
           exp_axi_wdata      <= exp_axi_wdata  - 1'd 1;
           exp_axi_wuser      <= exp_axi_wuser  - 2'd 2;
           exp_axi_wlast      <= ~exp_axi_wlast;
           exp_axi_wstrb      <= { C_AXI_STB_WIDTH { 1'b 1 } };

           if ( ( exp_axi_wdata != m_axi_wdata ) | ( exp_axi_wuser != m_axi_wuser ) |
                ( exp_axi_wlast != m_axi_wlast ) | ( exp_axi_wstrb != m_axi_wstrb ) )
           begin
              w_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_wdata !== m_axi_wdata ) | ( exp_axi_wuser !== m_axi_wuser ) |
                ( exp_axi_wlast !== m_axi_wlast ) | ( exp_axi_wstrb !== m_axi_wstrb ) )
           begin
              $display ( " ERROR :: W Mismatch exp_axi_wdata = %h, exp_axi_wuser   = %h, exp_axi_wlast = %h, exp_axi_wstrb = %h",
                           exp_axi_wdata , exp_axi_wuser   , exp_axi_wlast , exp_axi_wstrb );
              $display ( " ERROR :: W Mismatch   m_axi_wdata = %h,   m_axi_wuser   = %h,   m_axi_wlast = %h,   m_axi_wstrb = %h",
                           m_axi_wdata , m_axi_wuser   , m_axi_wlast , m_axi_wstrb );
              $stop;
           end
           else
           begin
              $display ( " W Match exp_axi_wdata = %h, exp_axi_wuser   = %h, exp_axi_wlast = %h, exp_axi_wstrb = %h",
                           exp_axi_wdata , exp_axi_wuser   , exp_axi_wlast , exp_axi_wstrb );
              $display ( " W Match   m_axi_wdata = %h,   m_axi_wuser   = %h,   m_axi_wlast = %h,   m_axi_wstrb = %h",
                           m_axi_wdata , m_axi_wuser   , m_axi_wlast , m_axi_wstrb );
           end
           // synthesis translate_on
        end
     end
  end

  always @ ( posedge s_axi_aclk or negedge s_axi_reset_n)
  begin
     if ( s_axi_reset_n == 1'b 0 )
     begin
        exp_axi_bid      <= { C_AXI_ID_WIDTH { 1'b 0 } };
        exp_axi_bresp    <= { C_AXI_RESP_WIDTH { 1'b 1 } };
  
        exp_axi_rdata    <= { C_AXI_DATA_WIDTH { 1'b 1 } };
        exp_axi_rid      <= { C_AXI_ID_WIDTH { 1'b 1 } };
        exp_axi_rlast    <= 1'b 0;
        exp_axi_rresp    <= { C_AXI_RESP_WIDTH { 1'b 0 } };
  
        r_error_reg          <= 1'b 0;
        b_error_reg          <= 1'b 0;
     end
     else
     begin
        if ( s_axi_bvalid & s_axi_bready )
        begin
           exp_axi_bid        <= exp_axi_bid   + 1'b 1;
           exp_axi_bresp      <= exp_axi_bresp - 1'b 1;
           if ( ( exp_axi_bid != s_axi_bid ) | ( exp_axi_bresp != s_axi_bresp ))
           begin
              b_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_bid !== s_axi_bid ) | ( exp_axi_bresp !== s_axi_bresp ) )
           begin
              $display ( "ERROR :: B Mismatch exp_axi_bid   = %h, exp_axi_bresp = %h", exp_axi_bid , exp_axi_bresp);
              $display ( "ERROR :: B Mismatch   s_axi_bid   = %h,   s_axi_bresp = %h", s_axi_bid , s_axi_bresp);
              $stop;
           end
           else
           begin
              $display ( "B Match exp_axi_bid   = %h, exp_axi_bresp = %h", exp_axi_bid , exp_axi_bresp);
              $display ( "B Match   s_axi_bid   = %h,   s_axi_bresp = %h", s_axi_bid , s_axi_bresp);
           end
           // synthesis translate_on
        end
        if ( s_axi_rvalid & s_axi_rready )
        begin
           exp_axi_rdata      <= exp_axi_rdata + 2'd 3;
           exp_axi_rid        <= exp_axi_rid   + 2'd 2;
           exp_axi_rlast      <= ~exp_axi_rlast;
           exp_axi_rresp      <= exp_axi_rresp + 1'd 1;
           if ( ( exp_axi_rdata    != s_axi_rdata ) | ( exp_axi_rid      != s_axi_rid   ) |
                ( exp_axi_rlast    != s_axi_rlast ) | ( exp_axi_rresp    != s_axi_rresp ) )
           begin
              r_error_reg <= 1'b 1;
           end
           // synthesis translate_off
           if ( ( exp_axi_rdata    !== s_axi_rdata ) | ( exp_axi_rid      !== s_axi_rid   ) |
                ( exp_axi_rlast    !== s_axi_rlast ) | ( exp_axi_rresp    !== s_axi_rresp ) )
           begin
              $display ( "ERROR :: R Mismatch exp_axi_rdata  = %h, exp_axi_rid    = %h, exp_axi_rlast  = %h, exp_axi_rresp  = %h",
                          exp_axi_rdata  , exp_axi_rid    , exp_axi_rlast  , exp_axi_rresp );
              $display ( "ERROR :: R Mismatch   s_axi_rdata  = %h,   s_axi_rid    = %h,   s_axi_rlast  = %h,   s_axi_rresp  = %h",
                          s_axi_rdata  , s_axi_rid    , s_axi_rlast  , s_axi_rresp );
              $stop;
           end
           else
           begin
              $display ( "R Match exp_axi_rdata  = %h, exp_axi_rid    = %h, exp_axi_rlast  = %h, exp_axi_rresp  = %h",
                          exp_axi_rdata  , exp_axi_rid    , exp_axi_rlast  , exp_axi_rresp );
              $display ( "R Match   s_axi_rdata  = %h,   s_axi_rid    = %h,   s_axi_rlast  = %h,   s_axi_rresp  = %h",
                          s_axi_rdata  , s_axi_rid    , s_axi_rlast  , s_axi_rresp );
           end
           // synthesis translate_on
        end
     end
  end

end
endgenerate


endmodule
