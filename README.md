# Thin-Film-Lithium-Tantalate-Polarization-Controller-Code-And-Electronics

This repository contains the control-system hardware associated with the work:

**“First Thin-Film Lithium Tantalate Polarization Controller Enabling Reset-Free Mrad·s⁻¹ Tracking for Optical Interconnects”**

## Notes on the hardware design files

1. The real-time polarization-control system was designed using the **professional version of LCEDA**, including both the **schematic design** and **PCB layout**.

2. For broader compatibility, the LCEDA design files were exported and converted into **Altium Designer (AD)** format. However, since these files are **not in the native AD format**, some graphical inconsistencies or display errors may occur. Therefore, the AD files are recommended **for design reference only**, rather than for further development.

3. For any further design modification or development, it is strongly recommended to use the **original LCEDA source files**.
   
4. The FPGA core board adopts Alientek MPSoC XCZU4EV Core Board

Ps：**LCEDA** (Chinese: 嘉立创EDA)  Version used: **V2.1.64**；**Alientek**(Chinese: 正点原子)


## Software Part

1. The FBGD convergence algorithm for the control system is written in Verilog.
2. FPGA developed using Xilinx's Vivado 2022.1.
   
## License

This repository is released under the GNU General Public License v3.0.

The authors primarily provide this repository to support academic research, verification, and educational use related to the accompanying paper:

**“First Thin-Film Lithium Tantalate Polarization Controller Enabling Reset-Free Mrad·s⁻¹ Tracking for Optical Interconnects”**

If you use this repository in academic work, please cite the associated paper appropriately.

For industrial collaboration or other commercial cooperation, please contact the authors.