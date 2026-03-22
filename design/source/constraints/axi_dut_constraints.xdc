set_property HD.CLK_SRC BUFGCTRL_X0Y2 [get_ports clk]
create_clock -period 10.000 -name axi_clk -waveform {0.000 5.000} [get_ports clk]

#input/output delay constaints....

#All s_axi_* and *_s ports (but not clk or reset)
#Somewhat meaningless because the these internal input/output ports are being measured against have no skew on them (ignore 'rst' line because it probably has async resets on it unlike 's_axis_aresetn')
set_input_delay -clock [get_clocks axi_clk] -min -add_delay 2.500 [get_ports s_axi_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*reset*"}]
set_input_delay -clock [get_clocks axi_clk] -max -add_delay 5.000 [get_ports s_axi_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*reset*"}]
set_output_delay -clock [get_clocks axi_clk] -min -add_delay 0.000 [get_ports s_axi_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*reset*"}]
set_output_delay -clock [get_clocks axi_clk] -max -add_delay 2.500 [get_ports s_axi_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*reset*"}]
#The reset for this particular AXI firmware is syncronous (not sure that is part of the AXI standard but lets go with it for the moment as this project is more about the UVM testbench)
set_input_delay -clock [get_clocks axi_clk] -min -add_delay 2.500 [get_ports rst -filter {DIRECTION == IN}]
set_input_delay -clock [get_clocks axi_clk] -max -add_delay 5.000 [get_ports rst -filter {DIRECTION == IN}]


##Old axis constaints..
##All axis_* ports (but not clk or reset)
##Somewhat meaningless because the these internal input/output ports are being measured against have no skew on them (ignore 'rst' line because it probably has async resets on it unlike 's_axis_aresetn')
#set_input_delay -clock [get_clocks axis_clk] -min -add_delay 2.500 [get_ports ?_axis_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
#set_input_delay -clock [get_clocks axis_clk] -max -add_delay 5.000 [get_ports ?_axis_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
#set_output_delay -clock [get_clocks axis_clk] -min -add_delay 0.000 [get_ports ?_axis_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]
#set_output_delay -clock [get_clocks axis_clk] -max -add_delay 2.500 [get_ports ?_axis_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]

