
# Introduction

This a noddy design to prove the following....

With VHDL you can compile files to different libraries in Vivado.  With V/SV you can't so they all go into work library and so there is no way they to differentiate 2 modules with the same name. Only OOC synth them to a netlist will work as Vivado does for IP by default.

It's entirely possible you would have 2 modules of the same name with different code in a larger design.

This can be seen by the 2 files listed in 'set files [list \' in file ./design/vivado/project_1_broken.tcl

    systemverilog_library_problem/domain_cross_slow_and_fast.sv

..is always chosen over file..

    broken/domain_cross_slow_and_fast.sv

..no matter how you order this list. If 'broken/domain_cross_slow_and_fast.sv' was used it would cause './check_broken_build_the_same.sh' to fail as it would change the build output .bin file's md5sum.



## To Build

### In Termial

    git clone https://github.com/stevefarmer01/systemverilog_library_problem.git
    . /opt/Xilinx/Vivado/2019.2/settings64.sh
    vivado -mode batch -source project_1.tcl
    cd project_1
    vivado project_1.xpr

### In Vivado GUI

    Generate Bitstream -> YES -> OK -> Cancel (when build finished)

Wait for build to finish then..

### In Termial

    ./check_build_the_same.sh

..if build output file '' is bit acurate then this should return

    PASSES no_git FIRMWARE BUILD


## To Build Broken

    . /opt/Xilinx/Vivado/2019.2/settings64.sh
    vivado -mode batch -source project_1_broken.tcl
    cd project_1_broken
    vivado project_1_broken.xpr

### In Vivado GUI

    Generate Bitstream -> YES -> OK -> Cancel (when build finished)

Wait for build to finish then..

### In Termial

    ./check_broken_build_the_same.sh

..if build output file '' is bit acurate then this should return

    PASSES no_git FIRMWARE BUILD

