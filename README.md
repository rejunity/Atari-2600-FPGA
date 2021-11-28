# Atari-2600
Atari 2600 in Verilog.

Based on the Daniel Beer's earlier work ["Atari on an FPGA"](https://people.ece.cornell.edu/land/courses/eceprojectsland/STUDENTPROJ/2006to2007/dbb26/dbb28_meng_report.pdf).

## Plan

1. Replace CPU 6502 VHDL implementation with Verilog.
    - [ ] Integrate Andrew Holme [Verilog 6502](http://www.aholme.co.uk/6502/Main.htm) core
    - [ ] Integrate Arlet Ottens [Verilog 6502](https://github.com/Arlet/verilog-6502) core
- Minimize vendor dependent code, move it out of the main files.
    - [ ] Remove PLL from mySystem.v
    - [ ] Separate folder for IceBreaker and Altera specific code
- Make codebase compatible with the open-source tools: [iverilog](http://iverilog.icarus.com/), [yosys](https://github.com/YosysHQ/yosys).
    - [ ] Makefile
- Testbench, coco_tb, compare to python emu
- Try to fit on open-source [iCEBreaker FPGA](https://www.crowdsupply.com/1bitsquared/icebreaker-fpga) (Lattice iCE40UP5k).
- [ASIC](https://www.zerotoasiccourse.com/)! :)
