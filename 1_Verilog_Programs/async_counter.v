`timescale 1ns / 1ps

// 4-bit asynchronous (ripple) up counter built from T flip-flops.
// Each stage is clocked by the output of the previous stage.
module async_counter(
    input clk, reset,
    output [3:0] q
);
    t_ff t0(.clk(clk),  .reset(reset), .q(q[0]));
    t_ff t1(.clk(q[0]), .reset(reset), .q(q[1]));
    t_ff t2(.clk(q[1]), .reset(reset), .q(q[2]));
    t_ff t3(.clk(q[2]), .reset(reset), .q(q[3]));
endmodule

// T flip-flop with T = 1 (toggles on every falling clock edge), asynchronous reset
module t_ff(
    input clk, reset,
    output reg q
);
    always @(negedge clk or posedge reset) begin
        if (reset) q <= 1'b0;
        else       q <= ~q;
    end
endmodule
