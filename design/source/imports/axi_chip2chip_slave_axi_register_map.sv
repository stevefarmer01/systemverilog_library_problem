/**
 * @file    axi_chip2chip_slave_axi_register_map.sv
 * @author  Steve Farmer
 * @date    19 June 2025
 * @note    Originally named 'generic_axi_axis_ip_axi_register_map.sv' from C:/Users/srfarmer1/git_remote/miscellaneous/simple_project.git
 * @brief   AXI4LITE low level interface for creating a register map'
 */

//Language: System Verilog 2009

`include "axi_chip2chip_slave_ip_svh.svh"

//Use generic_axi_axis_ip_pkg::NAME_OF_THING instead of catch all line below..
//import generic_axi_axis_ip_pkg::*;

module axi_chip2chip_slave_axi_register_map
  #(
    parameter integer C_S_AXI_DATA_WIDTH    = 32,
    parameter integer C_S_AXI_ADDR_WIDTH    = 6,
    parameter integer NUM_REGS = (2**(C_S_AXI_ADDR_WIDTH-2))
  )
  (
    //axi_reg_map_if.reg_map_master_modport     axi_register_map_master, // Downgrade from SV syntax to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
    input wire                                s_axi_aclk_control_status, // Downgrade from SV syntax to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
    input wire                                s_axi_aresetn_control_status, // Downgrade from SV syntax to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0]     s_axi_awaddr_control_status,
    input wire [2 : 0]                        s_axi_awprot_control_status,
    input wire                                s_axi_awvalid_control_status,
    output wire                               s_axi_awready_control_status,
    input wire [C_S_AXI_DATA_WIDTH-1 : 0]     s_axi_wdata_control_status,
    input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] s_axi_wstrb_control_status,
    input wire                                s_axi_wvalid_control_status,
    output wire                               s_axi_wready_control_status,
    output wire [1 : 0]                       s_axi_bresp_control_status,
    output wire                               s_axi_bvalid_control_status,
    input wire                                s_axi_bready_control_status,
    input wire [C_S_AXI_ADDR_WIDTH-1 : 0]     s_axi_araddr_control_status,
    input wire [2 : 0]                        s_axi_arprot_control_status,
    input wire                                s_axi_arvalid_control_status,
    output wire                               s_axi_arready_control_status,
    output wire [C_S_AXI_DATA_WIDTH-1 : 0]    s_axi_rdata_control_status,
    output wire [1 : 0]                       s_axi_rresp_control_status,
    output wire                               s_axi_rvalid_control_status,
    input wire                                s_axi_rready_control_status
  );

  //This register file gives software contol over firmware's registers
  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reg, slv_read, slv_reset;

  chip2chip_axi_reg_map_if chip2chip_axi_register_map_master (); // Used instead of interface commented out port above to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
  always_comb begin
    chip2chip_axi_register_map_master.status_present = '1; // SV interface not used because this module is instantiated in a verilog module and so just set it to a constant to stop X
  end

  always_comb 
  begin
    //Set all unassigned bits in reset array to 0 otherwise X's can be read during behavioural simulation (FPGA's never values inside of them other than 1'b1 or 1'b0)
    slv_reset = '{default:'0};
    slv_read = '{default:'0};
    //Register 'control' (read/write)
    slv_read[CHIP2CHIP_CONTROL_OFFSET/4][CHIP2CHIP_CONTROL_ENABLE_BIT_OFFSET+:CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH] = slv_reg[CHIP2CHIP_CONTROL_OFFSET/4][CHIP2CHIP_CONTROL_ENABLE_BIT_OFFSET+:CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH];
    slv_reset[CHIP2CHIP_CONTROL_OFFSET/4][CHIP2CHIP_CONTROL_ENABLE_BIT_OFFSET+:CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH] = CHIP2CHIP_CONTROL_ENABLE_RESET;
    chip2chip_axi_register_map_master.control_enable = slv_reg[CHIP2CHIP_CONTROL_OFFSET/4][CHIP2CHIP_CONTROL_ENABLE_BIT_OFFSET+:CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH];
    //Register 'status' (read only from firmware logic)
    slv_read[CHIP2CHIP_STATUS_OFFSET/4][CHIP2CHIP_STATUS_PRESENT_BIT_OFFSET+:CHIP2CHIP_STATUS_PRESENT_BIT_WIDTH] = chip2chip_axi_register_map_master.status_present;
    slv_reset[CHIP2CHIP_STATUS_OFFSET/4][CHIP2CHIP_STATUS_PRESENT_BIT_OFFSET+:CHIP2CHIP_STATUS_PRESENT_BIT_WIDTH] = chip2chip_axi_register_map_master.status_present;
    //Register 'version' (read only from a constant)
    slv_read[CHIP2CHIP_VERSION_OFFSET/4][CHIP2CHIP_VERSION_VALUE_BIT_OFFSET+:CHIP2CHIP_VERSION_VALUE_BIT_WIDTH] = CHIP2CHIP_VERSION_VALUE_RESET;
    slv_reset[CHIP2CHIP_VERSION_OFFSET/4][CHIP2CHIP_VERSION_VALUE_BIT_OFFSET+:CHIP2CHIP_VERSION_VALUE_BIT_WIDTH] = CHIP2CHIP_VERSION_VALUE_RESET;
    chip2chip_axi_register_map_master.version_value = CHIP2CHIP_VERSION_VALUE_RESET;
    //Register 'scratch' (read/write)
    slv_read[CHIP2CHIP_SCRATCH_OFFSET/4][CHIP2CHIP_SCRATCH_BIT_OFFSET+:CHIP2CHIP_SCRATCH_BIT_WIDTH] = slv_reg[CHIP2CHIP_SCRATCH_OFFSET/4][CHIP2CHIP_SCRATCH_BIT_OFFSET+:CHIP2CHIP_SCRATCH_BIT_WIDTH];
    slv_reset[CHIP2CHIP_SCRATCH_OFFSET/4][CHIP2CHIP_SCRATCH_BIT_OFFSET+:CHIP2CHIP_SCRATCH_BIT_WIDTH] = CHIP2CHIP_SCRATCH_RESET;
    chip2chip_axi_register_map_master.scratch = slv_reg[CHIP2CHIP_SCRATCH_OFFSET/4][CHIP2CHIP_SCRATCH_BIT_OFFSET+:CHIP2CHIP_SCRATCH_BIT_WIDTH];
    //Register 'bypass' (read/write)
    slv_read[CHIP2CHIP_BYPASS_OFFSET/4][CHIP2CHIP_BYPASS_EVERYTHING_BIT_OFFSET+:CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH] = slv_reg[CHIP2CHIP_BYPASS_OFFSET/4][CHIP2CHIP_BYPASS_EVERYTHING_BIT_OFFSET+:CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH];
    slv_reset[CHIP2CHIP_BYPASS_OFFSET/4][CHIP2CHIP_BYPASS_EVERYTHING_BIT_OFFSET+:CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH] = CHIP2CHIP_BYPASS_EVERYTHING_RESET;
    chip2chip_axi_register_map_master.bypass_everything = slv_reg[CHIP2CHIP_BYPASS_OFFSET/4][CHIP2CHIP_BYPASS_EVERYTHING_BIT_OFFSET+:CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH];
  end

  axi_chip2chip_slave_axi_lite 
  #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) 
  axi_regfile_inst 
  (
    .slv_read(slv_read),                             // input  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_read,  // The readback ports.
    .slv_reg (slv_reg),                              // output logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reg,   // The register outputs.
    .slv_reset(slv_reset),                           // input  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reset, // The register reset values.
    .S_AXI_ACLK    (s_axi_aclk_control_status),      // .S_AXI_ACLK    (axi_register_map_master.clk),    // input wire  S_AXI_ACLK, // Downgrade from SV syntax to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
    .S_AXI_ARESETN (s_axi_aresetn_control_status),   // .S_AXI_ARESETN (axi_register_map_master.resetn), // input wire  S_AXI_ARESETN, // Downgrade from SV syntax to allow to instantiated in verilog upperlevel see generic_axi_axis_ip_axi_register_map.sv for original code
    .S_AXI_AWADDR  (s_axi_awaddr_control_status ),   // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_AWADDR,
    .S_AXI_AWPROT  (s_axi_awprot_control_status ),   // input wire [2 : 0] S_AXI_AWPROT,
    .S_AXI_AWVALID (s_axi_awvalid_control_status),   // input wire  S_AXI_AWVALID,
    .S_AXI_AWREADY (s_axi_awready_control_status),   // output wire  S_AXI_AWREADY,
    .S_AXI_WDATA   (s_axi_wdata_control_status  ),   // input wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_WDATA,
    .S_AXI_WSTRB   (s_axi_wstrb_control_status  ),   // input wire [(C_S_AXI_DATA_WIDTH/8)-1 : 0] S_AXI_WSTRB,
    .S_AXI_WVALID  (s_axi_wvalid_control_status ),   // input wire  S_AXI_WVALID,
    .S_AXI_WREADY  (s_axi_wready_control_status ),   // output wire  S_AXI_WREADY,
    .S_AXI_BRESP   (s_axi_bresp_control_status  ),   // output wire [1 : 0] S_AXI_BRESP,
    .S_AXI_BVALID  (s_axi_bvalid_control_status ),   // output wire  S_AXI_BVALID,
    .S_AXI_BREADY  (s_axi_bready_control_status ),   // input wire  S_AXI_BREADY,
    .S_AXI_ARADDR  (s_axi_araddr_control_status ),   // input wire [C_S_AXI_ADDR_WIDTH-1 : 0] S_AXI_ARADDR,
    .S_AXI_ARPROT  (s_axi_arprot_control_status ),   // input wire [2 : 0] S_AXI_ARPROT,
    .S_AXI_ARVALID (s_axi_arvalid_control_status),   // input wire  S_AXI_ARVALID,
    .S_AXI_ARREADY (s_axi_arready_control_status),   // output wire  S_AXI_ARREADY,
    .S_AXI_RDATA   (s_axi_rdata_control_status  ),   // output wire [C_S_AXI_DATA_WIDTH-1 : 0] S_AXI_RDATA,
    .S_AXI_RRESP   (s_axi_rresp_control_status  ),   // output wire [1 : 0] S_AXI_RRESP,
    .S_AXI_RVALID  (s_axi_rvalid_control_status ),   // output wire  S_AXI_RVALID,
    .S_AXI_RREADY  (s_axi_rready_control_status )    // input wire  S_AXI_RREADY
  );

endmodule
