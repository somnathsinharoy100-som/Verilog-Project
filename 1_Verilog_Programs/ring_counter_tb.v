`timescale 1ns / 1ps

module ring_counter_tb;
    reg clk, reset;
    wire [3:0] count;

    ring_counter DUT(.clk(clk), .reset(reset), .count(count));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        $dumpfile("ring_counter.vcd");
        $dumpvars(0, ring_counter_tb);
        $monitor("t=%0t reset=%b count=%b", $time, reset, count);

        repeat (2) @(negedge clk);
        reset = 0;
        repeat (10) @(negedge clk);
        $finish;
    end
endmodule
