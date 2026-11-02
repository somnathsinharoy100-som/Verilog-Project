`timescale 1ns / 1ps

// Even-parity generator: parity bit makes the total number of 1s even
module parity_generator_4bit(
    input  [3:0] data,
    output parity
);
    assign parity = ^data;
endmodule

// Even-parity checker: error = 1 when data + parity bit contain an odd number of 1s
module parity_checker_4bit(
    input  [3:0] data,
    input  parity_in,
    output error
);
    assign error = ^{parity_in, data};
endmodule
