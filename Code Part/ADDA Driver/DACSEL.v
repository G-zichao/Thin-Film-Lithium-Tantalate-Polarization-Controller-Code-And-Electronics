

module DACSEL#(
    parameter DW =14
)(
    input Cail_en,
    input signed [DW-1:0]LNin_DAC1,LNin_DAC2,LNin_DAC3,LNin_DAC4,
    input signed [DW-1:0]Phiin_DAC1,Phiin_DAC2,Phiin_DAC3,Phiin_DAC4,
    output signed [DW-1:0]DAC1,DAC2,DAC3,DAC4
);
    assign DAC1 = (Cail_en) ? (Phiin_DAC1) : (LNin_DAC1);
    assign DAC2 = (Cail_en) ? (Phiin_DAC2) : (LNin_DAC2);
    assign DAC3 = (Cail_en) ? (Phiin_DAC3) : (LNin_DAC3);
    assign DAC4 = (Cail_en) ? (Phiin_DAC4) : (LNin_DAC4);
endmodule