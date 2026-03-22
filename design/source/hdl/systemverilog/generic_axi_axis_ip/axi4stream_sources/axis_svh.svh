//Local to ./design/source/hdl/systemverilog/generic_axi_axis_ip/axi4stream_sources/
`ifndef axis_svh
  `define axis_svh

  `define right(width) width>0?width-1:0

  `define default_DATA_WIDTH 32

   interface axi_stream_if #(
      parameter DATA_WIDTH =  `default_DATA_WIDTH,
      parameter KEEP_ENABLE =  0,
      parameter KEEP_WIDTH =  1,
      parameter LAST_ENABLE =  1,
      parameter ID_ENABLE =  0,
      parameter ID_WIDTH =  1,
      parameter DEST_ENABLE =  0,
      parameter DEST_WIDTH =  1,
      parameter USER_ENABLE =  1,
      parameter USER_WIDTH =  1
    )
    ( 
      input clk, resetn
    );
      logic [`right(DATA_WIDTH):0] tdata;
      logic [`right(KEEP_WIDTH):0] tkeep;
      logic                        tvalid;
      logic                        tready;
      logic                        tlast;
      logic [`right(ID_WIDTH):0]   tid;
      logic [`right(DEST_WIDTH):0] tdest;
      logic [`right(USER_WIDTH):0] tuser;

    modport axi_stream_master_modport ( 
                                    input clk, resetn,
                                    output tdata, tkeep, tvalid, tlast, tid, tdest, tuser,
                                    input tready
                                   );
    modport axi_stream_slave_modport  (
                                    input clk, resetn,
                                    input tdata, tkeep, tvalid, tlast, tid, tdest, tuser,
                                    output tready
                                   );

      ////////////////////////////////////////////////////////////////////////////
      // clocking block and modport declaration for monitor 
      ////////////////////////////////////////////////////////////////////////////
      clocking rc_cb@(posedge clk) ;
        input resetn;
        input tdata;
        input tkeep;
        input tvalid;
        inout tready;
        input tlast;
        input tid;
        input tdest;
        input tuser;
      endclocking
      
      //modport RCV (clocking rc_cb,input clk,resetn);

      ////////////////////////////////////////////////////////////////////////////
      // clocking block and modport declaration for driver 
      ////////////////////////////////////////////////////////////////////////////
      clocking dr_cb@(posedge clk) ;
        input resetn;
        output tdata;
        output tkeep;
        output tvalid;
        input tready;
        output tlast;
        output tid;
        output tdest;
        output tuser;
      endclocking
    
      //modport DRV (clocking dr_cb,input clk,resetn) ;

      function void print(string tag="");
        $display("Interface - %s label [%s]", "axi_stream_if", tag);
        $display("tdata  h'%h", tdata);
        $display("tkeep  h'%h", tkeep);
        $display("tvalid h'%h", tvalid);
        $display("tready h'%h", tready);
        $display("tlast  h'%h", tlast);
        $display("tid    h'%h", tid);
        $display("tdest  h'%h", tdest);
        $display("tuser  h'%h", tuser);
      endfunction

   endinterface

   //Simulation only interface for reset generation
   interface axi_stream_reset_if #(
    )
    ( 
      input clk//,
      //output resetn // Vivado 2019.2 will not drive this as an output (works in 2020.1 and 2023.2) and so use internal signal bwlow and port out at top level
    );
    logic resetn;

      ////////////////////////////////////////////////////////////////////////////
      // clocking block for syncronous reset 
      ////////////////////////////////////////////////////////////////////////////
      clocking dr_reset@(posedge clk) ;
        output resetn;
      endclocking

   endinterface

`endif
