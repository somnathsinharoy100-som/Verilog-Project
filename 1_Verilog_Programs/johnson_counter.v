`timescale 1ns / 1ps

module johnson_counter(
    input clk, reset,
    output [3:0] count
);
    d_ff d1(.clk(clk), .reset(reset), .d(~count[3]), .q(count[0]));
    d_ff d2(.clk(clk), .reset(reset), .d(count[0]),  .q(count[1]));
    d_ff d3(.clk(clk), .reset(reset), .d(count[1]),  .q(count[2]));
    d_ff d4(.clk(clk), .reset(reset), .d(count[2]),  .q(count[3]));
endmodule

module d_ff(
    input clk, reset, d,
    output reg q
);
    always @(posedge clk) begin
        if (reset) q <= 1'b0;
        else       q <= d;
    end
endmodule
