`timescale 1ns / 1ps

module ring_counter(
    input clk, reset,
    output [3:0] count
);
    d_ff_ring d1(.clk(clk), .reset(reset), .d(count[3]), .q(count[0]), .reset_value(1'b1));
    d_ff_ring d2(.clk(clk), .reset(reset), .d(count[0]), .q(count[1]), .reset_value(1'b0));
    d_ff_ring d3(.clk(clk), .reset(reset), .d(count[1]), .q(count[2]), .reset_value(1'b0));
    d_ff_ring d4(.clk(clk), .reset(reset), .d(count[2]), .q(count[3]), .reset_value(1'b0));
endmodule

module d_ff_ring(
    input clk, reset, d, reset_value,
    output reg q
);
    always @(posedge clk) begin
        if (reset) q <= reset_value;
        else       q <= d;
    end
endmodule
