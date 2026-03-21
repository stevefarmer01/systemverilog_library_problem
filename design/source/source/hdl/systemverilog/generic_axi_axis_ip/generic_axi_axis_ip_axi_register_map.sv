//Language: System Verilog 2009

`include "generic_axi_axis_ip_svh.svh"

//Use generic_axi_axis_ip_pkg::NAME_OF_THING instead of catch all line below..
//import generic_axi_axis_ip_pkg::*;

module generic_axi_axis_ip_axi_register_map
  #(
    parameter integer C_S_AXI_DATA_WIDTH    = 32,
    parameter integer C_S_AXI_ADDR_WIDTH    = 6,
    parameter integer NUM_REGS = (2**(C_S_AXI_ADDR_WIDTH-2))
  )
  (
    axi_reg_map_if.reg_map_master_modport     axi_register_map_master,
    //input wire                                s_axi_aclk_control_status,
    //input wire                                s_axi_aresetn_control_status,
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

  always_comb 
  begin
    //Register 'control' (read/write)
    slv_read[CONTROL_OFFSET/4][CONTROL_ENABLE_BIT_OFFSET+:CONTROL_ENABLE_BIT_WIDTH] = slv_reg[CONTROL_OFFSET/4][CONTROL_ENABLE_BIT_OFFSET+:CONTROL_ENABLE_BIT_WIDTH];
    slv_reset[CONTROL_OFFSET/4][CONTROL_ENABLE_BIT_OFFSET+:CONTROL_ENABLE_BIT_WIDTH] = CONTROL_ENABLE_RESET;
    axi_register_map_master.control_enable = slv_reg[CONTROL_OFFSET/4][CONTROL_ENABLE_BIT_OFFSET+:CONTROL_ENABLE_BIT_WIDTH];
    //Register 'status' (read only from firmware logic)
    slv_read[STATUS_OFFSET/4][STATUS_PRESENT_BIT_OFFSET+:STATUS_PRESENT_BIT_WIDTH] = axi_register_map_master.status_present;
    slv_reset[STATUS_OFFSET/4][STATUS_PRESENT_BIT_OFFSET+:STATUS_PRESENT_BIT_WIDTH] = axi_register_map_master.status_present;
    //Register 'version' (read only from a constant)
    slv_read[VERSION_OFFSET/4][VERSION_VALUE_BIT_OFFSET+:VERSION_VALUE_BIT_WIDTH] = VERSION_VALUE_RESET;
    slv_reset[VERSION_OFFSET/4][VERSION_VALUE_BIT_OFFSET+:VERSION_VALUE_BIT_WIDTH] = VERSION_VALUE_RESET;
    axi_register_map_master.version_value = VERSION_VALUE_RESET;
    //Register 'scratch' (read/write)
    slv_read[SCRATCH_OFFSET/4][SCRATCH_BIT_OFFSET+:SCRATCH_BIT_WIDTH] = slv_reg[SCRATCH_OFFSET/4][SCRATCH_BIT_OFFSET+:SCRATCH_BIT_WIDTH];
    slv_reset[SCRATCH_OFFSET/4][SCRATCH_BIT_OFFSET+:SCRATCH_BIT_WIDTH] = SCRATCH_RESET;
    axi_register_map_master.scratch = slv_reg[SCRATCH_OFFSET/4][SCRATCH_BIT_OFFSET+:SCRATCH_BIT_WIDTH];
    //Register 'bypass' (read/write)
    slv_read[BYPASS_OFFSET/4][BYPASS_EVERYTHING_BIT_OFFSET+:BYPASS_EVERYTHING_BIT_WIDTH] = slv_reg[BYPASS_OFFSET/4][BYPASS_EVERYTHING_BIT_OFFSET+:BYPASS_EVERYTHING_BIT_WIDTH];
    slv_reset[BYPASS_OFFSET/4][BYPASS_EVERYTHING_BIT_OFFSET+:BYPASS_EVERYTHING_BIT_WIDTH] = BYPASS_EVERYTHING_RESET;
    axi_register_map_master.bypass_everything = slv_reg[BYPASS_OFFSET/4][BYPASS_EVERYTHING_BIT_OFFSET+:BYPASS_EVERYTHING_BIT_WIDTH];
  end

  axi_regfile_v1_0_s00_axi 
  #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) 
  axi_regfile_inst 
  (
    .slv_read(slv_read),                             // input  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_read,  // The readback ports.
    .slv_reg (slv_reg),                              // output logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reg,   // The register outputs.
    .slv_reset(slv_reset),                           // input  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reset, // The register reset values.
    .S_AXI_ACLK    (axi_register_map_master.clk),    // input wire  S_AXI_ACLK,
    .S_AXI_ARESETN (axi_register_map_master.resetn), // input wire  S_AXI_ARESETN,
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
