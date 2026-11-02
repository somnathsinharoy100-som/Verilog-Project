`timescale 1ns / 1ps

module mealy_fsm(
    input clk, reset, in,
    output reg out
);
    reg [1:0] ps_state, nxt_state;
    parameter s0=2'b00, s1=2'b01, s2=2'b10;

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
            s2: if (in) nxt_state = s1; else nxt_state = s0;
            default: nxt_state = s0;
        endcase
    end

    // Separate Mealy output logic
    always @(*) begin
        out = 1'b0;
        if ((ps_state == s2) && (in == 1'b1))
            out = 1'b1;
    end
endmodule
