# Thin-Film-Lithium-Tantalate-Polarization-Controller-Code-And-Electronics

This repository contains the control-system hardware associated with the work:

**“Ultrafast Reset-Free Integrated Polarization Tracking Enabled by Thin-Film Lithium Tantalate”**

## Notes on the hardware design files

1. The real-time polarization-control system was designed using the **professional version of LCEDA**, including both the **schematic design** and **PCB layout**.

2. For broader compatibility, the LCEDA design files were exported and converted into **Altium Designer (AD)** format. However, since these files are **not in the native AD format**, some graphical inconsistencies or display errors may occur. Therefore, the AD files are recommended **for design reference only**, rather than for further development.

3. For any further design modification or development, it is strongly recommended to use the **original LCEDA source files**.
   
4. The FPGA core board adopts Alientek MPSoC XCZU4EV Core Board

Ps：**LCEDA** (Chinese: 嘉立创EDA)  Version used: **V2.1.64**；**Alientek**(Chinese: 正点原子)

## Code Part

1. The code part contains the FBGD control algorithm and the driver code for the real-time polarization-control system.

2. The **ADDA Driver** folder contains the Verilog driver code for the **AD9643** ADC and **AD9744** DAC, together with the corresponding delay-alignment logic.

3. The **ADC SPI Driver** folder contains the SPI register-configuration code for the **AD9643** ADC.

4. The **FBGD Part** folder contains the implementation of the **FBGD control algorithm**, compiled using a mixed **SystemVerilog + Verilog** flow.

5. The **FPGA Pin Constraints** folder contains the FPGA pin-constraint files for the corresponding hardware control system.
   
## License

This repository is released under the GNU General Public License v3.0.

The authors primarily provide this repository to support academic research, verification, and educational use related to the accompanying paper:

**“Ultrafast Reset-Free Integrated Polarization Tracking Enabled by Thin-Film Lithium Tantalate”**

If you use this repository in academic work, please cite the associated paper appropriately.

For industrial collaboration or other commercial cooperation, please contact the authors.