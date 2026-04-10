`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/28 11:28:02
// Design Name: 
// Module Name: LNCTRL_TOPV3
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


module LNCTRL_TOPV4#(
    parameter DW = 14,
    parameter DACMAX = 8191,
    parameter DACMIN = -8192
)(

    input sys_clk,
    input sys_rst_n,
    input signed [DW-1:0] ad_data,
    // debug part
    input LOCK_EN,
    input signed [7:0]ADC_DELAY,
    input signed [DW-1:0]INITIAL_STEP,
    input signed [DW-1:0]Kxin,Kgin,
    input signed [DW:0]PHI1_RANGE,
    input signed [DW:0]PHI2_RANGE,
    input signed [DW:0]PHI3_RANGE,
    input signed [DW:0]PHI4_RANGE,
    output  [4:0]FSM,
    output  [7:0]DELAY_CNT,
    //end debug part
    output  signed[DW-1:0] da_data1,
    output  signed[DW-1:0] da_data2,
    output  signed[DW-1:0] da_data3,
    output  signed[DW-1:0] da_data4
    );
    //kx kg buffer
    reg signed [DW-1:0] Kx,Kx1,Kx2,Kx3;
    reg signed [DW-1:0] Kg,Kg1,Kg2,Kg3;
    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            Kx1 <=0;
            Kg1 <=0;
            Kg<=0;
            Kx<=0;
            Kx2 <=0;
            Kg2 <=0;
            Kx3 <=0;
            Kg3 <=0;
        end
        else begin
            Kx1 <= Kxin;
            Kx2 <= Kx1;
            Kx3 <= Kx2;
            Kx <= Kx3;
            Kg1 <= Kgin;
            Kg2 <= Kg1;
            Kg3 <= Kg2;
            Kg <= Kg3;
        end
    end

    LNCTRL_V4#(
        .DW(DW),
        .DACMAX(DACMAX),
        .DACMIN(DACMIN)
    ) lnctrl_v2_inst(
        .sys_clk(sys_clk),
        .sys_rst_n(sys_rst_n),
        .ad_data(ad_data),
        //debug port
        .Kx(Kx),
        .Kg(Kg),
        .LOCK_EN(LOCK_EN),
        .ADC_DELAY(ADC_DELAY),
        .INITIAL_STEP(INITIAL_STEP),
        .FSM(FSM),
        .DELAY_CNT(DELAY_CNT),
        .PHI1_RANGE(PHI1_RANGE),
        .PHI2_RANGE(PHI2_RANGE),
        .PHI3_RANGE(PHI3_RANGE),
        .PHI4_RANGE(PHI4_RANGE),
        //end debug port
        .da_data1(da_data1),
        .da_data2(da_data2),
        .da_data3(da_data3),
        .da_data4(da_data4)
    ); 
endmodule
