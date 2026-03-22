
#set this property for clock because without this constraint, timing analysis may not be accurate and upstream checks cannot be done to ensure correct clock placement and causings warning..
#[Route 35-197] Clock port "clk" does not have an associated HD.CLK_SRC. Without this constraint, timing analysis may not be accurate and upstream checks cannot be done to ensure correct clock placement.
#set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports clk]
#create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

#set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports s_axi_aclk_control_status]
#create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports s_axi_aclk_control_status]

set_property HD.CLK_SRC BUFGCTRL_X0Y0 [get_ports s_axis_aclk]
#AXIS stream interfaces from/to Xilinx DMA IP running at 100 MHz
create_clock -period 10.000 -name axis_clk -waveform {0.000 5.000} [get_ports s_axis_aclk]
#Top level nano firmware's rx clock which genrates this clock is - AD9361 ADC clock speed = 61.44 MHz
#create_clock -period 16.276 -name axis_clk -waveform {0.000 8.138} [get_ports s_axis_aclk]

set_property HD.CLK_SRC BUFGCTRL_X0Y1 [get_ports s_axi_aclk]
create_clock -period 10.000 -name axi_clk -waveform {0.000 5.000} [get_ports s_axi_aclk]

#input/output delay constaints....

#All axis_* ports (but not clk or reset)
#Somewhat meaningless because the these internal input/output ports are being measured against have no skew on them (ignore 'rst' line because it probably has async resets on it unlike 's_axis_aresetn')
set_input_delay -clock [get_clocks axis_clk] -min -add_delay 2.500 [get_ports ?_axis_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_input_delay -clock [get_clocks axis_clk] -max -add_delay 5.000 [get_ports ?_axis_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_output_delay -clock [get_clocks axis_clk] -min -add_delay 0.000 [get_ports ?_axis_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_output_delay -clock [get_clocks axis_clk] -max -add_delay 2.500 [get_ports ?_axis_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]

#All s_axi_* ports (but not clk or reset)
#Somewhat meaningless because the these internal input/output ports are being measured against have no skew on them (ignore 'rst' line because it probably has async resets on it unlike 's_axis_aresetn')
set_input_delay -clock [get_clocks axi_clk] -min -add_delay 2.500 [get_ports s_axi_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_input_delay -clock [get_clocks axi_clk] -max -add_delay 5.000 [get_ports s_axi_* -filter {DIRECTION == IN && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_output_delay -clock [get_clocks axi_clk] -min -add_delay 0.000 [get_ports s_axi_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_output_delay -clock [get_clocks axi_clk] -max -add_delay 2.500 [get_ports s_axi_* -filter {DIRECTION == OUT && NAME !~ "*clk*" && NAME !~ "*rst*"}]

##All other ports (that are not ?_axis_*, s_axi_*, clk or reset)
#All other INPUTS
set_input_delay -clock [get_clocks axis_clk] -min -add_delay 2.500 [get_ports * -filter {DIRECTION == IN && NAME !~ "?_axis_*" && NAME !~ "s_axi_*" && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_input_delay -clock [get_clocks axis_clk] -max -add_delay 5.000 [get_ports * -filter {DIRECTION == IN && NAME !~ "?_axis_*" && NAME !~ "s_axi_*" && NAME !~ "*clk*" && NAME !~ "*rst*"}]
#All other OUTPUTS
set_output_delay -clock [get_clocks axis_clk] -min -add_delay 0.000 [get_ports * -filter {DIRECTION == OUT && NAME !~ "?_axis_*" && NAME !~ "s_axi_*" && NAME !~ "*clk*" && NAME !~ "*rst*"}]
set_output_delay -clock [get_clocks axis_clk] -max -add_delay 2.500 [get_ports * -filter {DIRECTION == OUT && NAME !~ "?_axis_*" && NAME !~ "s_axi_*" && NAME !~ "*clk*" && NAME !~ "*rst*"}]

#Specific ports to other clocks

#set_input_delay -clock [get_clocks another_clk] -min -add_delay 2.500 [get_ports another_port]
#set_input_delay -clock [get_clocks another_clk] -max -add_delay 5.000 [get_ports another_port]
#set_output_delay -clock [get_clocks another_clk] -min -add_delay 0.000 [get_ports another_port]
#set_output_delay -clock [get_clocks another_clk] -max -add_delay 2.500 [get_ports another_port]
