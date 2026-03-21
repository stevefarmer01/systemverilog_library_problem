
# Introduction

Welcome to my one of my only problems with SV.

With VHDL you can compile files to different libraries in Vivado.  With V/SV you can't so they all go into work library and so there is no way they to differentiate 2 modules with the same name. Only OOC synth them to a netlist will work as Vivado does for IP by default.

It's entirely possible you would have 2 modules of the same name with different code in a larger design.

I too have renamed them in the past. Pain in the butt.

When I get the time I will knock up a noddy design.