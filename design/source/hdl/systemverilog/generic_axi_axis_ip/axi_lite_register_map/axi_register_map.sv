// Example of how to use module 'axi_regfile_v1_0_s00_axi' to create a custom AXI4LITE register map

module axi_register_map
  #(
    parameter integer C_S_AXI_DATA_WIDTH  = 32,
    parameter integer C_S_AXI_ADDR_WIDTH  = 6,
    parameter integer NUM_REGS = (2**(C_S_AXI_ADDR_WIDTH-2))
  )
  (
    input wire                                s_axi_aclk_control_status,
    input wire                                s_axi_aresetn_control_status,
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

//    logic [3:0] led;
//
//    logic [27:0] led_count;
//    always_ff @(posedge s_axi_aclk_control_status) led_count <= led_count + 1;
//    assign led[3:2] = led_count[27:26];

  // This register file gives software contol over unit under test (UUT).
  logic [NUM_REGS-1:0][C_S_AXI_DATA_WIDTH-1:0] slv_reg, slv_read;

  assign slv_read[0] = slv_reg[0];

//    assign slv_read[0] = 32'hdeadbeef;
//    assign slv_read[1] = 32'h76543210;
//
//    assign led[1:0] = slv_reg[2][1:0];
//    assign slv_read[2] = slv_reg[2];
//
//    assign slv_read[15:3] = slv_reg[15:3];

  axi_regfile_v1_0_s00_axi 
  #(
    .C_S_AXI_DATA_WIDTH(C_S_AXI_DATA_WIDTH),
    .C_S_AXI_ADDR_WIDTH(C_S_AXI_ADDR_WIDTH)
  ) 
  axi_regfile_inst 
  (
    //register interface
    .slv_read(slv_read),
    .slv_reg (slv_reg),
    //axi interface
    .S_AXI_ACLK    (s_axi_aclk_control_status),
    .S_AXI_ARESETN (s_axi_aresetn_control_status),
    .S_AXI_ARADDR  (s_axi_araddr_control_status ),
    .S_AXI_ARPROT  (s_axi_arprot_control_status ),
    .S_AXI_ARREADY (s_axi_arready_control_status),
    .S_AXI_ARVALID (s_axi_arvalid_control_status),
    .S_AXI_AWADDR  (s_axi_awaddr_control_status ),
    .S_AXI_AWPROT  (s_axi_awprot_control_status ),
    .S_AXI_AWREADY (s_axi_awready_control_status),
    .S_AXI_AWVALID (s_axi_awvalid_control_status),
    .S_AXI_BREADY  (s_axi_bready_control_status ),
    .S_AXI_BRESP   (s_axi_bresp_control_status  ),
    .S_AXI_BVALID  (s_axi_bvalid_control_status ),
    .S_AXI_RDATA   (s_axi_rdata_control_status  ),
    .S_AXI_RREADY  (s_axi_rready_control_status ),
    .S_AXI_RRESP   (s_axi_rresp_control_status  ),
    .S_AXI_RVALID  (s_axi_rvalid_control_status ),
    .S_AXI_WDATA   (s_axi_wdata_control_status  ),
    .S_AXI_WREADY  (s_axi_wready_control_status ),
    .S_AXI_WSTRB   (s_axi_wstrb_control_status  ),
    .S_AXI_WVALID  (s_axi_wvalid_control_status )
  );

endmodule

