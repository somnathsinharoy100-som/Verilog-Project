`timescale 1ns / 1ps

module moore_fsm(
    input clk, reset, in,
    output reg out
);
    reg [1:0] ps_state, nxt_state;
    parameter s0=2'b00, s1=2'b01, s2=2'b10, s3=2'b11;

    always @(posedge clk) begin
        if (reset) ps_state <= s0;
        else       ps_state <= nxt_state;
    end

    // Next-state logic for sequence 101
    always @(*) begin
        nxt_state = s0;
        case (ps_state)
            s0: if (in) nxt_state = s1; else nxt_state = s0;
            s1: if (in) nxt_state = s1; else nxt_state = s2;
            s2: if (in) nxt_state = s3; else nxt_state = s0;
            s3: if (in) nxt_state = s1; else nxt_state = s2;
            default: nxt_state = s0;
        endcase
    end

    // Moore output depends only on current state
    always @(*) begin
        if (ps_state == s3) out = 1'b1;
        else                out = 1'b0;
    end
endmodule
