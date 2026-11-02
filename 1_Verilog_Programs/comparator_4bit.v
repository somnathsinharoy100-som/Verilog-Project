`timescale 1ns / 1ps

module comparator_4bit(
    input  [3:0] a, b,
    output gt,   // a > b
    output eq,   // a == b
    output lt    // a < b
);
    assign gt = (a > b);
    assign eq = (a == b);
    assign lt = (a < b);
endmodule
