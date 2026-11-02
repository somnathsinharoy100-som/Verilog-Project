`timescale 1ns / 1ps

module universal_shift_reg_4bit(
    input clk, reset,
    input [1:0] mode,
    input serial_in,
    input [3:0] parallel_in,
    output reg [3:0] Q,
    output serial_out
);
    wire [3:0] right_data, left_data, load_data, next_Q;

    assign serial_out = Q[0];

    shift_right_4bit SR1(.Q(Q), .serial_in(serial_in), .next_Q(right_data));
    shift_left_4bit  SL1(.Q(Q), .serial_in(serial_in), .next_Q(left_data));
    load_4bit        PL1(.parallel_in(parallel_in), .next_Q(load_data));
    mux_4to1_4bit    M1(.Q(Q), .right_data(right_data),
                        .left_data(left_data), .load_data(load_data),
                        .mode(mode), .next_Q(next_Q));

    always @(posedge clk) begin
        if (reset) Q <= 4'b0000;
        else       Q <= next_Q;
    end
endmodule

module shift_right_4bit(input [3:0] Q, input serial_in, output [3:0] next_Q);
    assign next_Q = {serial_in, Q[3:1]};
endmodule

module shift_left_4bit(input [3:0] Q, input serial_in, output [3:0] next_Q);
    assign next_Q = {Q[2:0], serial_in};
endmodule

module load_4bit(input [3:0] parallel_in, output [3:0] next_Q);
    assign next_Q = parallel_in;
endmodule

module mux_4to1_4bit(
    input [3:0] Q, right_data, left_data, load_data,
    input [1:0] mode,
    output reg [3:0] next_Q
);
    always @(*) begin
        case (mode)
            2'b00: next_Q = Q;
            2'b01: next_Q = right_data;
            2'b10: next_Q = left_data;
            2'b11: next_Q = load_data;
            default: next_Q = Q;
        endcase
    end
endmodule
