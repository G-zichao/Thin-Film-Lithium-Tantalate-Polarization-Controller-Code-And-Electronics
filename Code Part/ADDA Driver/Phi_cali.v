

module Phi_Cali#(
    parameter DW =14
)(
    input sys_clk,
    input sys_rst_n,
    input [1:0]Ch_sel,
    input signed [DW-1:0]DAC_MAX,DAC_MIN,
    output reg signed [DW-1:0]DAC1,DAC2,DAC3,DAC4
);

    always @(posedge sys_clk) begin
        if (!sys_rst_n) begin
            DAC1<=0;
            DAC2<=0;
            DAC3<=0;
            DAC4<=0;
        end
        else begin
            case (Ch_sel)
                2'd0:begin
                    if (DAC1<DAC_MAX) begin
                        DAC1<=DAC1+1;
                    end
                    else begin
                        DAC1<=DAC_MIN;
                    end
                end
                2'd1:begin
                    if (DAC2<DAC_MAX) begin
                        DAC2<=DAC2+1;
                    end
                    else begin
                        DAC2<=DAC_MIN;
                    end
                end 
                2'd2:begin
                    if (DAC3<DAC_MAX) begin
                        DAC3<=DAC3+1;
                    end
                    else begin
                        DAC3<=DAC_MIN;
                    end
                    
                end
                2'd3:begin
                    if (DAC4<DAC_MAX) begin
                        DAC4<=DAC4+1;
                    end
                    else begin
                        DAC4<=DAC_MIN;
                    end
                end
                default:begin
                    DAC1<=DAC1;
                    DAC2<=DAC2;
                    DAC3<=DAC3;
                    DAC4<=DAC4;
                end 
            endcase
        end
    end
 
    
endmodule