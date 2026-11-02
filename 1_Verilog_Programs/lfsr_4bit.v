`timescale 1ns / 1ps

// 4-bit maximal-length LFSR, polynomial x^4 + x^3 + 1.
// Cycles through 15 non-zero states (the all-zero state is never reached).
module lfsr_4bit(
    input clk, reset,
    output reg [3:0] q,
    output rand_bit
);
    wire feedback;
    assign feedback = q[3] ^ q[2];
    assign rand_bit = q[3];

    always @(posedge clk) begin
        if (reset) q <= 4'b0001;               // non-zero seed
        else       q <= {q[2:0], feedback};
    end
endmodule
