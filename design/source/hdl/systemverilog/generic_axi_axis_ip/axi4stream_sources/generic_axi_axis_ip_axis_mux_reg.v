/*

Copyright (c) 2014-2018 Alex Forencich

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

*/

// Language: Verilog 2001

`timescale 1ns / 1ps

/*
 * AXI4-Stream multiplexer
 */

module generic_axi_axis_ip_axis_mux_reg #
(
    parameter S_COUNT = 2,                     // = 4,              // Number of AXI stream inputs
    parameter DATA_WIDTH = 32,                 // = 8,              // Width of AXI stream interfaces in bits
    parameter DIASABLE_SWITCHING_ON_TLAST = 1, // = 1,              // Original design of 'axis_mux.v' only switchedo on frame boundries as indicated by tlast, this caused interuptions on tready out when tlast high
    parameter KEEP_ENABLE = 0,                 // = (DATA_WIDTH>8), // Propagate tkeep signal
    parameter KEEP_WIDTH = 1,                  // = (DATA_WIDTH/8), // tkeep signal width (words per cycle)
    parameter ID_ENABLE = 0,                   // = 0,              // Propagate tid signal
    parameter ID_WIDTH = 1,                    // = 8,              // tid signal width
    parameter DEST_ENABLE = 0,                 // = 0,              // Propagate tdest signal
    parameter DEST_WIDTH = 1,                  // = 8,              // tdest signal width
    parameter USER_ENABLE = 1,                 // = 1,              // Propagate tuser signal
    parameter USER_WIDTH = 1                   // = 1               // tuser signal width
)
(
    input  wire                          clk,
    input  wire                          rst,

    /*
     * AXI inputs
     */
    input  wire [S_COUNT*DATA_WIDTH-1:0] s_axis_tdata,
    input  wire [S_COUNT*KEEP_WIDTH-1:0] s_axis_tkeep,
    input  wire [S_COUNT-1:0]            s_axis_tvalid,
    output wire [S_COUNT-1:0]            s_axis_tready,
    input  wire [S_COUNT-1:0]            s_axis_tlast,
    input  wire [S_COUNT*ID_WIDTH-1:0]   s_axis_tid,
    input  wire [S_COUNT*DEST_WIDTH-1:0] s_axis_tdest,
    input  wire [S_COUNT*USER_WIDTH-1:0] s_axis_tuser,

    /*
     * AXI output
     */
    output wire [DATA_WIDTH-1:0]         m_axis_tdata,
    output wire [KEEP_WIDTH-1:0]         m_axis_tkeep,
    output wire                          m_axis_tvalid,
    input  wire                          m_axis_tready,
    output wire                          m_axis_tlast,
    output wire [ID_WIDTH-1:0]           m_axis_tid,
    output wire [DEST_WIDTH-1:0]         m_axis_tdest,
    output wire [USER_WIDTH-1:0]         m_axis_tuser,

    /*
     * Control
     */
    input  wire                          enable,
    input  wire [$clog2(S_COUNT)-1:0]    select
);

parameter CL_S_COUNT = $clog2(S_COUNT);

reg [CL_S_COUNT-1:0] select_reg = 2'd0, select_next;
reg frame_reg = DIASABLE_SWITCHING_ON_TLAST, frame_next = DIASABLE_SWITCHING_ON_TLAST; //reg frame_reg = 1'b1, frame_next = 1'b1;

reg [S_COUNT-1:0] s_axis_tready_reg = 0, s_axis_tready_next;

// internal datapath
reg  [DATA_WIDTH-1:0] m_axis_tdata_int;
reg  [KEEP_WIDTH-1:0] m_axis_tkeep_int;
reg                   m_axis_tvalid_int;
reg                   m_axis_tready_int_reg = 1'b0;
reg                   m_axis_tlast_int;
reg  [ID_WIDTH-1:0]   m_axis_tid_int;
reg  [DEST_WIDTH-1:0] m_axis_tdest_int;
reg  [USER_WIDTH-1:0] m_axis_tuser_int;
wire                  m_axis_tready_int_early;

assign s_axis_tready = s_axis_tready_reg;

// mux for incoming packet
wire [DATA_WIDTH-1:0] current_s_tdata  = s_axis_tdata[select_reg*DATA_WIDTH +: DATA_WIDTH];
wire [KEEP_WIDTH-1:0] current_s_tkeep  = s_axis_tkeep[select_reg*KEEP_WIDTH +: KEEP_WIDTH];
wire                  current_s_tvalid = s_axis_tvalid[select_reg];
wire                  current_s_tready = s_axis_tready[select_reg];
wire                  current_s_tlast  = s_axis_tlast[select_reg];
wire [ID_WIDTH-1:0]   current_s_tid    = s_axis_tid[select_reg*ID_WIDTH +: ID_WIDTH];
wire [DEST_WIDTH-1:0] current_s_tdest  = s_axis_tdest[select_reg*DEST_WIDTH +: DEST_WIDTH];
wire [USER_WIDTH-1:0] current_s_tuser  = s_axis_tuser[select_reg*USER_WIDTH +: USER_WIDTH];

always @* begin
    select_next = select_reg;
    frame_next = frame_reg;

    s_axis_tready_next = 0;

    if (current_s_tvalid & current_s_tready) begin
        // end of frame detection
        if (current_s_tlast) begin
            if (DIASABLE_SWITCHING_ON_TLAST == 1) frame_next = 1'b1; else frame_next = 1'b0;
        end
    end

    if (DIASABLE_SWITCHING_ON_TLAST == 1) begin
        frame_next = 1'b1;
        select_next = select;
    end else begin
        if (!frame_reg && enable && (s_axis_tvalid & (1 << select))) begin
            // start of frame, grab select value
            frame_next = 1'b1;
            select_next = select;
        end
    end

    // generate ready signal on selected port
    s_axis_tready_next = (m_axis_tready_int_early && frame_next) << select_next;

    // pass through selected packet data
    m_axis_tdata_int  = current_s_tdata;
    m_axis_tkeep_int  = current_s_tkeep;
    m_axis_tvalid_int = current_s_tvalid && current_s_tready && frame_reg;
    m_axis_tlast_int  = current_s_tlast;
    m_axis_tid_int    = current_s_tid;
    m_axis_tdest_int  = current_s_tdest;
    m_axis_tuser_int  = current_s_tuser;
end

always @(posedge clk) begin
    if (rst) begin
        select_reg <= 0;
        if (DIASABLE_SWITCHING_ON_TLAST == 1) frame_reg <= 1'b1; else frame_reg <= 1'b0;
        s_axis_tready_reg <= 0;
    end else begin
        select_reg <= select_next;
        frame_reg <= frame_next;
        s_axis_tready_reg <= s_axis_tready_next;
    end
end

// output datapath logic
reg [DATA_WIDTH-1:0] m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
reg [KEEP_WIDTH-1:0] m_axis_tkeep_reg  = {KEEP_WIDTH{1'b0}};
reg                  m_axis_tvalid_reg = 1'b0, m_axis_tvalid_next;
reg                  m_axis_tlast_reg  = 1'b0;
reg [ID_WIDTH-1:0]   m_axis_tid_reg    = {ID_WIDTH{1'b0}};
reg [DEST_WIDTH-1:0] m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
reg [USER_WIDTH-1:0] m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

reg [DATA_WIDTH-1:0] temp_m_axis_tdata_reg  = {DATA_WIDTH{1'b0}};
reg [KEEP_WIDTH-1:0] temp_m_axis_tkeep_reg  = {KEEP_WIDTH{1'b0}};
reg                  temp_m_axis_tvalid_reg = 1'b0, temp_m_axis_tvalid_next;
reg                  temp_m_axis_tlast_reg  = 1'b0;
reg [ID_WIDTH-1:0]   temp_m_axis_tid_reg    = {ID_WIDTH{1'b0}};
reg [DEST_WIDTH-1:0] temp_m_axis_tdest_reg  = {DEST_WIDTH{1'b0}};
reg [USER_WIDTH-1:0] temp_m_axis_tuser_reg  = {USER_WIDTH{1'b0}};

// datapath control
reg store_axis_int_to_output;
reg store_axis_int_to_temp;
reg store_axis_temp_to_output;

assign m_axis_tdata  = m_axis_tdata_reg;
assign m_axis_tkeep  = KEEP_ENABLE ? m_axis_tkeep_reg : {KEEP_WIDTH{1'b1}};
assign m_axis_tvalid = m_axis_tvalid_reg;
assign m_axis_tlast  = m_axis_tlast_reg;
assign m_axis_tid    = ID_ENABLE   ? m_axis_tid_reg   : {ID_WIDTH{1'b0}};
assign m_axis_tdest  = DEST_ENABLE ? m_axis_tdest_reg : {DEST_WIDTH{1'b0}};
assign m_axis_tuser  = USER_ENABLE ? m_axis_tuser_reg : {USER_WIDTH{1'b0}};

// enable ready input next cycle if output is ready or the temp reg will not be filled on the next cycle (output reg empty or no input)
assign m_axis_tready_int_early = m_axis_tready || (!temp_m_axis_tvalid_reg && (!m_axis_tvalid_reg || !m_axis_tvalid_int));

always @* begin
    // transfer sink ready state to source
    m_axis_tvalid_next = m_axis_tvalid_reg;
    temp_m_axis_tvalid_next = temp_m_axis_tvalid_reg;

    store_axis_int_to_output = 1'b0;
    store_axis_int_to_temp = 1'b0;
    store_axis_temp_to_output = 1'b0;

    if (m_axis_tready_int_reg) begin
        // input is ready
        if (m_axis_tready || !m_axis_tvalid_reg) begin
            // output is ready or currently not valid, transfer data to output
            m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_output = 1'b1;
        end else begin
            // output is not ready, store input in temp
            temp_m_axis_tvalid_next = m_axis_tvalid_int;
            store_axis_int_to_temp = 1'b1;
        end
    end else if (m_axis_tready) begin
        // input is not ready, but output is ready
        m_axis_tvalid_next = temp_m_axis_tvalid_reg;
        temp_m_axis_tvalid_next = 1'b0;
        store_axis_temp_to_output = 1'b1;
    end
end

always @(posedge clk) begin
    if (rst) begin
        m_axis_tvalid_reg <= 1'b0;
        m_axis_tready_int_reg <= 1'b0;
        temp_m_axis_tvalid_reg <= 1'b0;
    end else begin
        m_axis_tvalid_reg <= m_axis_tvalid_next;
        m_axis_tready_int_reg <= m_axis_tready_int_early;
        temp_m_axis_tvalid_reg <= temp_m_axis_tvalid_next;
    end

    // datapath
    if (store_axis_int_to_output) begin
        m_axis_tdata_reg <= m_axis_tdata_int;
        m_axis_tkeep_reg <= m_axis_tkeep_int;
        m_axis_tlast_reg <= m_axis_tlast_int;
        m_axis_tid_reg   <= m_axis_tid_int;
        m_axis_tdest_reg <= m_axis_tdest_int;
        m_axis_tuser_reg <= m_axis_tuser_int;
    end else if (store_axis_temp_to_output) begin
        m_axis_tdata_reg <= temp_m_axis_tdata_reg;
        m_axis_tkeep_reg <= temp_m_axis_tkeep_reg;
        m_axis_tlast_reg <= temp_m_axis_tlast_reg;
        m_axis_tid_reg   <= temp_m_axis_tid_reg;
        m_axis_tdest_reg <= temp_m_axis_tdest_reg;
        m_axis_tuser_reg <= temp_m_axis_tuser_reg;
    end

    if (store_axis_int_to_temp) begin
        temp_m_axis_tdata_reg <= m_axis_tdata_int;
        temp_m_axis_tkeep_reg <= m_axis_tkeep_int;
        temp_m_axis_tlast_reg <= m_axis_tlast_int;
        temp_m_axis_tid_reg   <= m_axis_tid_int;
        temp_m_axis_tdest_reg <= m_axis_tdest_int;
        temp_m_axis_tuser_reg <= m_axis_tuser_int;
    end
end

endmodule

