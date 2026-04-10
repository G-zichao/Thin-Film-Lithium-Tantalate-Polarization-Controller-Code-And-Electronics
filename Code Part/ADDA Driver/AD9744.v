`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/05/05 19:56:56
// Design Name: 
// Module Name: AD9744
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module AD9744#(
    parameter DW = 14
)(
    input sys_clk,
    input sys_rst_n,
    input signed [DW-1:0]data_in,
    output signed [DW-1:0]DAC_out,
    output signed [DW-1:0]DAC_debug,
    output  DACCLK_p,DACCLK_n
    );
    assign DACCLK_p = sys_clk;
    assign DACCLK_n = ~sys_clk;
    assign DAC_out = data_in;
    assign DAC_debug = data_in;

    


    // always @(negedge sys_clk) begin
    //     if (!sys_rst_n) begin
    //         DAC_out<=0;
    //         DAC_debug<=0;
    //     end
    //     else begin
    //         DAC_debug<=data_in;
    //         DAC_out<=data_in;  
    //     end
    // end
    // // dac out clk
    // ODDRE1#(
    //     .IS_C_INVERTED(1'b0),           // Optional inversion for C
    //     .IS_D1_INVERTED(1'b0),          // Unsupported, do not use
    //     .IS_D2_INVERTED(1'b0),          // Unsupported, do not use
    //     .SIM_DEVICE("ULTRASCALE_PLUS"), // Set the device version for simulation functionality
    //     .SRVAL(1'b0)                    // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
    // ) ODDR_dac_clockp_inst (
    //     .Q(DACCLK_p),   // 1-bit output: Data output to IOB
    //     .C(sys_clk),   // 1-bit input: High-speed clock input
    //     .D1(1'b1), // 1-bit input: Parallel data input 1
    //     .D2(1'b0), // 1-bit input: Parallel data input 2
    //     .SR()  // 1-bit input: Active-High Async Reset
    // );
    // ODDRE1#(
    //     .IS_C_INVERTED(1'b0),           // Optional inversion for C
    //     .IS_D1_INVERTED(1'b0),          // Unsupported, do not use
    //     .IS_D2_INVERTED(1'b0),          // Unsupported, do not use
    //     .SIM_DEVICE("ULTRASCALE_PLUS"), // Set the device version for simulation functionality
    //     .SRVAL(1'b0)                    // Initializes the ODDRE1 Flip-Flops to the specified value (1'b0, 1'b1)
    // ) ODDR_dac_clockn_inst (
    //     .Q(DACCLK_n),   // 1-bit output: Data output to IOB
    //     .C(sys_clk),   // 1-bit input: High-speed clock input
    //     .D1(1'b0), // 1-bit input: Parallel data input 1
    //     .D2(1'b1), // 1-bit input: Parallel data input 2
    //     .SR()  // 1-bit input: Active-High Async Reset
    // );

endmodule
