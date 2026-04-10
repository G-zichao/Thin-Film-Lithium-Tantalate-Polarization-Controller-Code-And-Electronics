`timescale 1ns / 1ps
//just for ln ctrl board v1
module AD9643_io#(
    parameter DATA_WIDTH = 14
)(
    input sys_clk,// 200Mhz
    input sys_rst_n,
    // input ref_clk, //300Mhz
    input signed [13:0]ADCin_N,ADCin_P, //ddr
    input DCON,DCOP,
    //debug port 

    //out port
    output logic signed [13:0]ADCDATA_1,ADCDATA_2
    );
    //debug port
    logic LOAD;
    logic [8:0]CNTVALUEIN[0:13];

    logic signed[13:0] ADCin,ADCdelay;
    logic RDY;
    logic DCO;
    genvar i;
    IBUFDS ibufds_DCO (
        .O(DCO),
        .I(DCOP),
        .IB(DCON)
    );

    // IDELAYCTRL #(
    // .SIM_DEVICE("ULTRASCALE") // Must be set to "ULTRASCALE_PLUS"
    // )
    // IDELAYCTRL_inst (
    // .RDY(RDY), // 1-bit output: Ready output
    // .REFCLK(ref_clk), // 1-bit input: Reference clock input
    // .RST() // 1-bit input: Active high reset input. Asynchronous assert, synchronous deassert to
    // // REFCLK.
    // );
generate
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin : GEN_IBUFDS_DATA
        IBUFDS ibufds_data_i (
            .O(ADCin[i]),
            .I(ADCin_P[i]),
            .IB(ADCin_N[i])
        );
        // IDELAYE3 #(
        //     .CASCADE("NONE"),               // Cascade setting (MASTER, NONE, SLAVE_END, SLAVE_MIDDLE)
        //     .DELAY_FORMAT("TIME"),          // Units of the DELAY_VALUE (COUNT, TIME)
        //     .DELAY_SRC("IDATAIN"),          // Delay input (DATAIN, IDATAIN)
        //     .DELAY_TYPE("VAR_LOAD"),           // Set the type of tap delay line (FIXED, VARIABLE, VAR_LOAD)
        //     .DELAY_VALUE(0),                // Input delay value setting
        //     .IS_CLK_INVERTED(1'b0),         // Optional inversion for CLK
        //     .IS_RST_INVERTED(1'b0),         // Optional inversion for RST
        //     .REFCLK_FREQUENCY(300.0),       // IDELAYCTRL clock input frequency in MHz (200.0-800.0) for
        //     .SIM_DEVICE("ULTRASCALE_PLUS"), // Set the device version for simulation functionality (ULTRASCALE, ULTRASCALE_PLUS, ULTRASCALE_PLUS_ES1,
        //     .UPDATE_MODE("ASYNC")           // Determines when updates to the delay will take effect (ASYNC, MANUAL, SYNC)
        // )
        // IDELAYE3_inst ( // delay time = 127ps + 4ps*DELAY_VALUE
        //     //no used ports
        //     .CASC_OUT(),       // 1-bit output: Cascade delay output to ODELAY input cascade
        //     .CASC_IN(),         // 1-bit input: Cascade delay input from slave ODELAY CASCADE_OUT
        //     .CASC_RETURN(), // 1-bit input: Cascade delay returning from slave ODELAY DATAOUT
        //     .DATAIN(),           // 1-bit input: Data input from the logic
        //     .INC(1'b0),                 // 1-bit input: Increment / Decrement tap delay input
        //     //.CNTVALUEOUT(CNTVALUEOUT), // 9-bit output: Counter value output
        //     .CE(1'b0),                   // 1-bit input: Active-High enable increment/decrement input
        //     .CLK(sys_clk),                 // 1-bit input: Clock input
        //     .LOAD(LOAD),               // 1-bit input: Load DELAY_VALUE input; active high
        //     .CNTVALUEIN(CNTVALUEIN[i]),   // 9-bit input: Counter value input
        //     //data in out
        //     .IDATAIN(ADCin[i]),         // 1-bit input: Data input from the IOBUF
        //     .DATAOUT(ADCdelay[i]),         // 1-bit output: Delayed data output
        //     //config
        //     .EN_VTC(1'b1),              // 1-bit input: Keep delay constant over VT
        //     .RST()                  // 1-bit input: Asynchronous Reset to the DELAY_VALUE  
        // );

    end
endgenerate

 // IDDR
generate
    for (i = 0; i < DATA_WIDTH; i = i + 1) begin : GEN_IDDR_DATA
        IDDRE1#(
            .DDR_CLK_EDGE("OPPOSITE_EDGE"),  //  "OPPOSITE_EDGE" or "SAME_EDGE" or "SAME_EDGE_PIPELINED"
            .IS_CB_INVERTED(1'b0), // Optional inversion for CB
            .IS_C_INVERTED(1'b0) // Optional inversion for C
        )iddr_inst (// if use idelay,input is ADCdelay, else is ADCin 
            .Q1(ADCDATA_1[i]), // 1-bit output: Registered parallel output 1
            .Q2(ADCDATA_2[i]), // 1-bit output: Registered parallel output 2
            .C(DCO),   // 1-bit input: High-speed clock
            .CB(~DCO), // 1-bit input: Inversion of High-speed clock C
            .D(ADCin[i]),   // 1-bit input: Serial Data Input
            .R()    // 1-bit input: Active-High Async Reset
        );
    end
endgenerate


   

endmodule