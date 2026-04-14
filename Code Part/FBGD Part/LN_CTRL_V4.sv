`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/10/28 
// Design Name: 
// Module Name: LNCTRL_V3
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


module LNCTRL_V4#(
    parameter DW = 14
)(
    input sys_clk,
    input sys_rst_n,
    input signed [DW-1:0] ad_data,
    // debug part
    input LOCK_EN,
    input [7:0]ADC_DELAY,
    input signed [DW-1:0]Kx,Kg,
    input signed [DW-1:0]INITIAL_STEP,
    output logic [4:0]FSM,
    output logic [7:0]DELAY_CNT,
    //end debug part
    output logic signed[DW-1:0] da_data1,
    output logic signed[DW-1:0] da_data2,
    output logic signed[DW-1:0] da_data3,
    output logic signed[DW-1:0] da_data4
    );

    logic signed [DW-1:0] PBASE;
    logic signed [DW-1:0] ad_data_buf;
    logic signed [DW-1:0] G1x,G2x,G3x,G4x;
    logic signed [DW-1:0] L1x,L2x,L3x,L4x;

    logic signed [DW-1:0] L1x_buf;
    logic signed [DW-1:0] L2x_buf;
    logic signed [DW-1:0] L3x_buf;
    logic signed [DW-1:0] L4x_buf;

    logic signed [DW-1:0] Phi1_step;
    logic signed [DW-1:0] Phi2_step;
    logic signed [DW-1:0] Phi3_step;
    logic signed [DW-1:0] Phi4_step;


     generate
        assign L1x_buf = ((2 * DW)'(G1x) * (2 * DW)'(Kg)) >>> (DW-1);
        assign L2x_buf = ((2 * DW)'(G2x) * (2 * DW)'(Kg)) >>> (DW-1);
        assign L3x_buf = ((2 * DW)'(G3x) * (2 * DW)'(Kg)) >>> (DW-1);
        assign L4x_buf = ((2 * DW)'(G4x) * (2 * DW)'(Kg)) >>> (DW-1);
        // step mult
        assign Phi1_step = ((2 * DW)'(Kx) * (2 * DW)'(da_data1)) >>> (DW-1);
        assign Phi2_step = ((2 * DW)'(Kx) * (2 * DW)'(da_data2)) >>> (DW-1);
        assign Phi3_step = ((2 * DW)'(Kx) * (2 * DW)'(da_data3)) >>> (DW-1);
        assign Phi4_step = ((2 * DW)'(Kx) * (2 * DW)'(da_data4)) >>> (DW-1);

    endgenerate


    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            da_data1<=0;
            da_data2<=0;
            da_data3<=0;
            da_data4<=0;
            PBASE<=0;
            G1x<=0;
            G2x<=0;
            G3x<=0;
            G4x<=0;
            L1x<=0;
            L2x<=0;
            L3x<=0;
            L4x<=0;
        end
        else begin
            case (FSM) // After dac1 change ,wait 16 cycles to read pbase,17:change1,18:change2,19:change3,20:change4
                4'd0: begin 
                    if (LOCK_EN) begin
                        da_data1<=da_data1+INITIAL_STEP;
                    end
                    else begin
                        da_data1<=da_data1;
                    end
                    da_data2<=da_data2;
                    da_data3<=da_data3;
                    da_data4<=da_data4;
                end
                4'd1: begin
                    da_data1<=da_data1-INITIAL_STEP;
                    da_data2<=da_data2+INITIAL_STEP;
                    da_data3<=da_data3;
                    da_data4<=da_data4;
                end
                4'd2: begin
                    da_data1<=da_data1;
                    da_data2<=da_data2-INITIAL_STEP;
                    da_data3<=da_data3+INITIAL_STEP;
                    da_data4<=da_data4;
                end
                4'd3: begin
                    da_data1<=da_data1;
                    da_data2<=da_data2;
                    da_data3<=da_data3-INITIAL_STEP;
                    da_data4<=da_data4+INITIAL_STEP;
                end
                4'd4: begin//hold on
                    da_data1<=da_data1;
                    da_data2<=da_data2;
                    da_data3<=da_data3;
                    da_data4<=da_data4; 
                end
                4'd5:begin //get P_base
                    da_data4<=da_data4-INITIAL_STEP;
                    PBASE<=ad_data;
                end
                4'd6:begin // lock adc data
                    G1x<=ad_data-PBASE;
                end
                4'd7:begin // rind L1x
                    L1x<= PBASE*L1x_buf + Phi1_step;
                    G2x<=ad_data-PBASE;
                end
                4'd8:begin // lock step1 & compute phi change
                    L2x<= PBASE*L2x_buf+Phi2_step;
                    G3x<=ad_data-PBASE;
                    da_data1<=da_data1-L1x;
                end
                4'd9:begin 
                    L3x<= PBASE*L3x_buf+Phi3_step;
                    G4x<=ad_data-PBASE;
                    da_data2<=da_data2-L2x;
                end
                4'd10:begin 
                    L4x<= PBASE*L4x_buf+Phi4_step;
                    da_data3<=da_data3-L3x;
                end
                4'd11:begin 
                    da_data4<=da_data4-L4x;
                end
                4'd12:begin //hold on 
                    da_data1<=da_data1;
                    da_data2<=da_data2;
                    da_data3<=da_data3;
                    da_data4<=da_data4;
                end
                default: begin
                    da_data1<=da_data1;
                    da_data2<=da_data2;
                    da_data3<=da_data3;
                    da_data4<=da_data4;
                end
            endcase
        end
    end 


    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            FSM<=0;
            DELAY_CNT<=0;
        end
        else begin
            if (LOCK_EN) begin
                if (FSM<3) begin
                FSM<=FSM+1'b1; // dac1 - dac2 -dac3 -dac4 set initial step
                DELAY_CNT<=0;
                end
                else if (DELAY_CNT<ADC_DELAY) begin
                    FSM<=4; // wait for adc delay
                    DELAY_CNT<=DELAY_CNT+1'b1;
                end
                else if (FSM<(4+4+4)) begin 
                    FSM<=FSM+1'b1;
                    DELAY_CNT<=DELAY_CNT;
                end
                else begin
                    FSM<=0; // back to initial state
                    DELAY_CNT<=0;
                end
            end
            else begin
                FSM<=0;
                DELAY_CNT<=0;
            end
        end
    end


endmodule
