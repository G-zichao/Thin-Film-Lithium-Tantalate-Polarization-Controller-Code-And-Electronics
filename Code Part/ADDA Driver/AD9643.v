`timescale 1ns / 1ps
//just for ln ctrl board v1
module AD9643#(
    parameter DW = 14,
    parameter DC = 8192
)(
    input sys_clk,// 200Mhz adc sample clk
    input sys_rst_n,
    // input ref_clk, //300Mhz
    input signed [13:0]ADCin_N,ADCin_P, //ddr
    input DCON,DCOP,
    input ORAN,ORAP,ORBN,ORBP, //input over range 
    //debug port 

    //out port
    output signed [DW-1:0]ADCA_out,ADCB_out,
    output OR_LED,OEB,
    output ADC_CLKP,ADC_CLKN
    );

    wire signed [13:0]ADCA_in,ADCB_in;
    wire ORA,ORB;
    wire signed [DW-1:0]DAC_DC;
    assign DAC_DC=14'd8191;
    assign OEB = 1'b0; //always enable the adc
    //DCO is negetive 

    assign ADCA_out ={ADCA_in[13],~ADCA_in[12:0]};
    assign ADCB_out ={ADCB_in[13],~ADCB_in[12:0]};
    AD9643_io AD9643_io_inst(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        // .ref_clk(ref_clk),
        .ADCin_N(ADCin_N),
        .ADCin_P(ADCin_P),
        .DCON(DCON),
        .DCOP(DCOP),
        .ADCDATA_1(ADCB_in),
        .ADCDATA_2(ADCA_in)
    );

    /* note 1 about output different clock
    dont direct use the obufs for clk output,
    use the oddr + obufs to reduce the jitter
    see the https://fpga.eetrend.com/blog/2021/100062950.html#
    */
    // ODDRE1: Dedicated Double Data Rate (DDR) Output Register
    //         UltraScale
    // Xilinx HDL Language Template, version 2025.1

    // wire adc_sample_clk;
    // ODDRE1#(
    //     .IS_C_INVERTED(1'b0),           // Optional inversion for C
    //     .IS_D1_INVERTED(1'b0),          // Unsupported, do not use
    //     .IS_D2_INVERTED(1'b0),          // Unsupported, do not use
    //     .SIM_DEVICE("ULTRASCALE_PLUS"), // Set the device version for simulation functionality
    //     .SRVAL(1'b0)                    // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
    // ) ODDR_adc_clock_inst (
    //     .Q(adc_sample_clk),   // 1-bit output: Data output to IOB
    //     .C(sys_clk),   // 1-bit input: High-speed clock input
    //     .D1(1'b1), // 1-bit input: Parallel data input 1
    //     .D2(1'b0), // 1-bit input: Parallel data input 2
    //     .SR(~sys_rst_n)  // 1-bit input: Active-High Async Reset
    // );
    OBUFDS OBUFDS_adc_clk_inst (
        .I(~sys_clk),
        .O(ADC_CLKP),     
        .OB(ADC_CLKN)     
    );

    //over range part 
    assign OR_LED = ORA|(~ORB);

    IBUFDS ADCORA (
        .O(ORA),
        .I(ORAP),
        .IB(ORAN)
    );
    IBUFDS ADCORB (
        .O(ORB),
        .I(ORBP),
        .IB(ORBN)
    );
    
endmodule