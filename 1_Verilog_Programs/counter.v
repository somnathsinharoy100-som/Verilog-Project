`timescale 1ns / 1ps

module counter(
    input clk,
    input reset,
    input mode,              // 1 = up, 0 = down
    output reg [3:0] count
);
    wire [3:0] up_count;
    wire [3:0] down_count;

    up_counter   U1(.count(count), .next_count(up_count));
    down_counter D1(.count(count), .next_count(down_count));

    always @(posedge clk) begin
        if (reset)
            count <= 4'b0000;
        else if (mode)
            count <= up_count;
        else
            count <= down_count;
    end
endmodule

module up_counter(
    input  [3:0] count,
    output [3:0] next_count
);
    assign next_count = count + 1'b1;
endmodule

module down_counter(
    input  [3:0] count,
    output [3:0] next_count
);
    assign next_count = count - 1'b1;
endmodule
