######## THIS IS THE CONSTRAINTS FOR THIS FILE ########

set data_in_clock           [get_clocks -of_objects [get_ports data_in_clk]]
set data_out_clock          [get_clocks -of_objects [get_ports data_out_clk]]
set data_in_clock_period    [get_property PERIOD $data_in_clock]
set data_out_clock_period   [get_property PERIOD $data_out_clock]
set shortest_clock_period   [expr {(($data_in_clock_period < $data_out_clock_period) ? $data_in_clock_period : $data_out_clock_period)} ]

#'set_max_delay' constraint appears to cause 'TIMING-18 | Warning  | Missing input or output delay' in report_methodology..
#This appears to be because input port/pin does not have registe driving it and so -datapath_only requires a path from driving register's C input to receiving registers D input

set_max_delay -from $data_in_clock -to [get_cells data_shift_array_reg[0][*]] -datapath_only $shortest_clock_period

#..and so use 'set_false_path' to make timing ignore this path completly..

#set_false_path -from $data_in_clock -to [get_cells data_shift_array_reg[0][*]]


