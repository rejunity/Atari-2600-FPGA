# Atari-2600
Atari 2600 in Verilog.

Based on the Daniel Beer's earlier work ["Atari on an FPGA"](https://people.ece.cornell.edu/land/courses/eceprojectsland/STUDENTPROJ/2006to2007/dbb26/dbb28_meng_report.pdf).

## Plan

1. Move away from VHDL 6502 to Verilog implementation.
2. Minimize vendor dependent code, move it out of the main files.
3. Make codebase compatible with the open-source tools: [iverilog](http://iverilog.icarus.com/), [yosys](https://github.com/YosysHQ/yosys).
4. Try to fit on open-source [iCEBreaker FPGA](https://www.crowdsupply.com/1bitsquared/icebreaker-fpga) (Lattice iCE40UP5k).
5. ASIC :)
