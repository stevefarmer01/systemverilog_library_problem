`ifndef axi_chip2chip_slave_ip_svh
  `define axi_chip2chip_slave_ip_svh

  //`define RSIZE 4
  //`define ISIZE 16


  //Register 'control'
  localparam int unsigned CHIP2CHIP_CONTROL_OFFSET = 32'h00000000;           // address offset
  //Bit addresses
  localparam CHIP2CHIP_CONTROL_ENABLE_BIT_OFFSET = 0;           // bit offset of the field
  localparam CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH = 1;            // bit width of the field
  localparam logic [0:0] CHIP2CHIP_CONTROL_ENABLE_RESET = 1'b0; // reset value of the field

  //Register 'status' (read only)
  localparam logic [31:0] CHIP2CHIP_STATUS_OFFSET = 32'h00000004;            // address offset of the 'status' register
  //Bit addresses
  localparam CHIP2CHIP_STATUS_PRESENT_BIT_OFFSET = 0;           // bit offset of the field
  localparam CHIP2CHIP_STATUS_PRESENT_BIT_WIDTH = 1;            // bit width of the field
  localparam logic [0:0] CHIP2CHIP_STATUS_PRESENT_RESET = 1'b1; // reset value of the field

  //Register 'version' (read only)
  localparam int unsigned CHIP2CHIP_VERSION_OFFSET = 32'h00000008;           // address offset of the 'version' register
  //Bit addresses
  localparam CHIP2CHIP_VERSION_VALUE_BIT_OFFSET = 0;                         // bit offset of the 'value' field
  localparam CHIP2CHIP_VERSION_VALUE_BIT_WIDTH = 32;                         // bit width of the 'value' field
  //Revision number of the  IP..
  //Versions
  //1    = Steve Farmer - First version for initial firmware development
  localparam logic [31:0] CHIP2CHIP_VERSION_VALUE_RESET = 32'h00000001;      // reset value of the 'value' field

  //Register 'scratch'
  localparam int unsigned CHIP2CHIP_SCRATCH_OFFSET = 32'h0000000C;           // address offset
  //Bit addresses
  localparam CHIP2CHIP_SCRATCH_BIT_OFFSET = 0;                               // bit offset of the field
  localparam CHIP2CHIP_SCRATCH_BIT_WIDTH = 32;                               // bit width of the field
  localparam logic [31:0] CHIP2CHIP_SCRATCH_RESET = 32'h76543210;            // reset value of the field

  //Register 'bypass'
  localparam logic [31:0] CHIP2CHIP_BYPASS_OFFSET = 32'h00000010;            // address offset of the 'bypass' register
  //Bit addresses
  localparam CHIP2CHIP_BYPASS_EVERYTHING_BIT_OFFSET = 0;                     // bit offset of the field
  localparam CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH = 1;                      // bit width of the field
  localparam logic [0:0] CHIP2CHIP_BYPASS_EVERYTHING_RESET = 1'b0;           // reset value of the field

  interface chip2chip_axi_reg_map_if (input clk, resetn);
    
    logic [CHIP2CHIP_CONTROL_ENABLE_BIT_WIDTH-1:0] control_enable;
    logic [CHIP2CHIP_STATUS_PRESENT_BIT_WIDTH-1:0] status_present;
    logic [CHIP2CHIP_VERSION_VALUE_BIT_WIDTH-1:0] version_value;
    logic [CHIP2CHIP_SCRATCH_BIT_WIDTH-1:0] scratch;
    logic [CHIP2CHIP_BYPASS_EVERYTHING_BIT_WIDTH-1:0] bypass_everything;

    //struct {logic balls;} st_scrotum; //Vivado 2019.1 - ERROR: [IP_Flow 19-4824] Ports (st_scrotum) in interface 'axi_reg_map_if' of design unit 'generic_axi_axis_ip' declared with SystemVerilog struct are not supported in this release. 

    modport chip2chip_reg_map_master_modport 
    ( 
      input clk, resetn,
      output control_enable, version_value, scratch, bypass_everything,
      input status_present
    );
    
    modport chip2chip_reg_map_slave_modport  
    (
      input clk, resetn,
      output status_present,
      input control_enable, version_value, scratch, bypass_everything
    );

  endinterface



   //interface axis_bypass_if;
   //  logic          axis_bypass_axis;
   //endinterface

   //interface axis_if;
   //  logic [31:0]    tdata;
   //  logic          tready;
   //  logic          tvalid;
   //  logic          tlast;
   //endinterface

  //// The interface allows verification components to access DUT signals
  //// using a virtual interface handle
  //interface axis_tb_if (input bit clk);
  //  logic aresetn;
  //  logic [63:0] tdata;
  //  logic tlast;
  //  logic tready;
  //  logic tuser;
  //  logic tvalid;
  //endinterface

`endif
