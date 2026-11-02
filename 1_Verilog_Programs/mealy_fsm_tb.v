`timescale 1ns / 1ps

module mealy_fsm_tb;
    reg clk, reset, in;
    wire out;
    integer errors;

    mealy_fsm DUT(.clk(clk), .reset(reset), .in(in), .out(out));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; in = 0; errors = 0;
        $dumpfile("mealy_fsm.vcd");
        $dumpvars(0, mealy_fsm_tb);
        $monitor("t=%0t reset=%b in=%b state=%b out=%b",
                 $time, reset, in, DUT.ps_state, out);

        repeat (2) @(negedge clk);
        reset = 0;

        // Feed 101; check output shortly after final input is driven
        @(negedge clk); in = 1;
        @(negedge clk); in = 0;
        @(negedge clk); in = 1; #1;
        if (out !== 1'b1) begin
            $display("FAIL: 101 was not detected"); errors = errors + 1;
        end else $display("PASS: 101 detected");

        // Feed 00 after detection; no new detection
        @(negedge clk); in = 0;
        @(negedge clk); in = 0; #1;
        if (out !== 1'b0) begin
            $display("FAIL: unexpected output"); errors = errors + 1;
        end else $display("PASS: no false detection");

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
