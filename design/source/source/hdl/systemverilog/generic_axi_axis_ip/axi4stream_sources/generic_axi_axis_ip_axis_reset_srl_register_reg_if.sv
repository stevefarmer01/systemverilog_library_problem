/**
 * @file    generic_axi_axis_ip_axis_reset_srl_register_reg_if.sv
 * @author  Steve Farmer
 * @date    20 Feb 2023
 * @brief   Systemverilog version of verilog 'axis_srl_register.v' from (https://github.com/alexforencich/verilog-axis)
 * @note    SRL-based register. SRLs on Xilinx FPGAs have a very fast input setup time, so this module can be used to aid in timing closure.
 */

//Language: System Verilog 2009

`timescale 1ns / 1ps

`include "axis_svh.svh"

module generic_axi_axis_ip_axis_reset_srl_register_reg_if #
(
    parameter DATA_WIDTH = 32,         // 8,              // Width of AXI stream interfaces in bits
    parameter KEEP_ENABLE = 0,         // (DATA_WIDTH>8), // Propagate tkeep signal
    parameter KEEP_WIDTH = 1,          // (DATA_WIDTH/8), // tkeep signal width (words per cycle)
    parameter LAST_ENABLE = 1,         // 1,              // Propagate tlast signal
    parameter ID_ENABLE = 0,           // 0,              // Propagate tid signal
    parameter ID_WIDTH = 1,            // 8,              // tid signal width
    parameter DEST_ENABLE = 0,         // 0,              // Propagate tdest signal
    parameter DEST_WIDTH = 1,          // 8,              // tdest signal width
    parameter USER_ENABLE = 1,         // 1,              // Propagate tuser signal                // set to 1 because TUSER is test post-synth and post-impl on 'testbench_top.sv'/'axi4stream_vip_0_exdes_tb.sv'
    parameter USER_WIDTH = 1           // 1               // tuser signal width                    // set to 1 because TUSER is test post-synth and post-impl on 'testbench_top.sv'/'axi4stream_vip_0_exdes_tb.sv'
)
(
    axi_stream_if.axi_stream_slave_modport axi_stream_slave,
    axi_stream_if.axi_stream_master_modport axi_stream_master
);

localparam KEEP_OFFSET = DATA_WIDTH;
localparam LAST_OFFSET = KEEP_OFFSET + (KEEP_ENABLE ? KEEP_WIDTH : 0);
localparam ID_OFFSET   = LAST_OFFSET + (LAST_ENABLE ? 1          : 0);
localparam DEST_OFFSET = ID_OFFSET   + (ID_ENABLE   ? ID_WIDTH   : 0);
localparam USER_OFFSET = DEST_OFFSET + (DEST_ENABLE ? DEST_WIDTH : 0);
localparam WIDTH       = USER_OFFSET + (USER_ENABLE ? USER_WIDTH : 0);

logic [1:0][WIDTH-1:0] data_reg = '{default:'0};
logic [1:0] valid_reg = '{default:'0};
reg ptr_reg = '0;
logic full_reg = '0;
logic [WIDTH-1:0] s_axis;
logic [WIDTH-1:0] m_axis;

always_comb axi_stream_slave.tready = !full_reg;

always_comb s_axis[DATA_WIDTH-1:0] = axi_stream_slave.tdata;
if (KEEP_ENABLE) always_comb s_axis[KEEP_OFFSET +: KEEP_WIDTH] = axi_stream_slave.tkeep;
if (LAST_ENABLE) always_comb s_axis[LAST_OFFSET]               = axi_stream_slave.tlast;
if (ID_ENABLE)   always_comb s_axis[ID_OFFSET   +: ID_WIDTH]   = axi_stream_slave.tid;
if (DEST_ENABLE) always_comb s_axis[DEST_OFFSET +: DEST_WIDTH] = axi_stream_slave.tdest;
if (USER_ENABLE) always_comb s_axis[USER_OFFSET +: USER_WIDTH] = axi_stream_slave.tuser;

always_comb axi_stream_master.tvalid = valid_reg[ptr_reg];

always_comb m_axis = data_reg[ptr_reg];

always_comb axi_stream_master.tdata = m_axis[DATA_WIDTH-1:0];
if (KEEP_ENABLE) always_comb axi_stream_master.tkeep = m_axis[KEEP_OFFSET +: KEEP_WIDTH];
if (LAST_ENABLE) always_comb axi_stream_master.tlast = m_axis[LAST_OFFSET]              ;
if (ID_ENABLE)   always_comb axi_stream_master.tid   = m_axis[ID_OFFSET   +: ID_WIDTH]  ;
if (DEST_ENABLE) always_comb axi_stream_master.tdest = m_axis[DEST_OFFSET +: DEST_WIDTH];
if (USER_ENABLE) always_comb axi_stream_master.tuser = m_axis[USER_OFFSET +: USER_WIDTH];

always_ff @(posedge axi_stream_slave.clk) begin
    int i;
    if (~axi_stream_slave.resetn) begin
        ptr_reg <= 0;
        full_reg <= 0;
        valid_reg <= '0;
    end else begin
        // transfer empty to full
        full_reg <= !axi_stream_master.tready && axi_stream_master.tvalid;

        // transfer in if not full
        if (axi_stream_slave.tready) begin
            data_reg[0] <= s_axis;
            valid_reg[0] <= axi_stream_slave.tvalid;
            for (i = 0; i < 1; i = i + 1) begin
                data_reg[i+1] <= data_reg[i];
                valid_reg[i+1] <= valid_reg[i];
            end
            ptr_reg <= valid_reg[0];
        end

        if (axi_stream_master.tready) begin
            ptr_reg <= 0;
        end
    end
end

endmodule

//Alternative method for setting register initialization values
//initial begin
//    for (i = 0; i < 2; i = i + 1) begin
//        data_reg[i] <= 0;
//        valid_reg[i] <= 0;
//    end
//end

