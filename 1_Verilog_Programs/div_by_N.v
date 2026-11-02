`timescale 1ns / 1ps

module div_by_N #(parameter N = 4)(
    input clk,
    input reset,
    output reg clk_out
);
    localparam CW = (N <= 1) ? 1 : $clog2(N);
    reg [CW-1:0] count;

    always @(posedge clk) begin
        if (reset) begin
            count   <= 0;
            clk_out <= 0;
        end else if (count == N-1) begin
            count   <= 0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1'b1;
        end
    end
endmodule
