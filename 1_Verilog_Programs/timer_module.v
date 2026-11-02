`timescale 1ns / 1ps

// Programmable down-counting timer.
// start=1 (while idle) loads load_val; the timer then counts down once per clock.
// done is a one-clock pulse when the count has expired.
module timer_module(
    input clk, reset, start,
    input [3:0] load_val,
    output reg [3:0] remaining,
    output reg running,
    output reg done
);
    always @(posedge clk) begin
        if (reset) begin
            remaining <= 4'd0;
            running   <= 1'b0;
            done      <= 1'b0;
        end else begin
            done <= 1'b0;                 // default: pulse lasts one cycle
            if (!running) begin
                if (start && (load_val != 4'd0)) begin
                    remaining <= load_val;
                    running   <= 1'b1;
                end
            end else begin
                if (remaining == 4'd1) begin
                    remaining <= 4'd0;
                    running   <= 1'b0;
                    done      <= 1'b1;
                end else
                    remaining <= remaining - 1'b1;
            end
        end
    end
endmodule
