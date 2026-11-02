`timescale 1ns / 1ps

module div_by_N_tb;
    reg clk, reset;
    wire clk_out;

    div_by_N #(.N(4)) DUT(.clk(clk), .reset(reset), .clk_out(clk_out));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1;
        $dumpfile("div_by_N.vcd");
        $dumpvars(0, div_by_N_tb);
        $monitor("t=%0t reset=%b clk=%b clk_out=%b", $time, reset, clk, clk_out);

        #12 reset = 0;
        #240;
        $finish;
    end
endmodule
