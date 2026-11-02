`timescale 1ns / 1ps

module barrel_shifter_4bit(
    input  [3:0] data,
    input  [1:0] shamt,
    input  [1:0] mode,
    output reg [3:0] out
);
    always @(*) begin
        case (mode)
            2'b00: out = data << shamt;                              // logical left
            2'b01: out = data >> shamt;                              // logical right
            2'b10: out = (data << shamt) | (data >> (4-shamt));      // rotate left
            2'b11: out = (data >> shamt) | (data << (4-shamt));      // rotate right
            default: out = data;
        endcase
    end
endmodule
