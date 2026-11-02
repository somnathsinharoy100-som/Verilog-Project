`timescale 1ns / 1ps

module counter_tb;
    reg clk, reset, mode;
    wire [3:0] count;

    counter DUT(.clk(clk), .reset(reset), .mode(mode), .count(count));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; mode = 1;
        $dumpfile("counter.vcd");
        $dumpvars(0, counter_tb);
        $monitor("t=%0t reset=%b mode=%b count=%b", $time, reset, mode, count);

        repeat (2) @(negedge clk);
        reset = 0;

        mode = 1;   // count up
        repeat (5) @(negedge clk);

        mode = 0;   // count down
        repeat (7) @(negedge clk);

        reset = 1;
        @(negedge clk);
        reset = 0;
        mode = 1;
        repeat (4) @(negedge clk);

        $finish;
    end
endmodule
