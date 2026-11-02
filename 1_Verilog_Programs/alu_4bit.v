`timescale 1ns / 1ps

module alu_4bit(
    input  [3:0] a, b,
    input  [2:0] op,
    output reg [3:0] result,
    output reg carry,       // carry-out (ADD), borrow (SUB), bit shifted out (shifts)
    output zero
);
    assign zero = (result == 4'b0000);

    always @(*) begin
        carry  = 1'b0;
        result = 4'b0000;
        case (op)
            3'b000: {carry, result} = a + b;                        // ADD
            3'b001: {carry, result} = {1'b0, a} - {1'b0, b};        // SUB (carry = borrow)
            3'b010: result = a & b;                                 // AND
            3'b011: result = a | b;                                 // OR
            3'b100: result = a ^ b;                                 // XOR
            3'b101: result = ~a;                                    // NOT A
            3'b110: {carry, result} = {a, 1'b0};                    // shift A left by 1
            3'b111: {result, carry} = {1'b0, a};                    // shift A right by 1
            default: result = 4'b0000;
        endcase
    end
endmodule
