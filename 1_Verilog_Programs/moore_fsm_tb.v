`timescale 1ns / 1ps

module moore_fsm_tb;
    reg clk, reset, in;
    wire out;
    integer errors;

    moore_fsm DUT(.clk(clk), .reset(reset), .in(in), .out(out));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; in = 0; errors = 0;
        $dumpfile("moore_fsm.vcd");
        $dumpvars(0, moore_fsm_tb);
        $monitor("t=%0t reset=%b in=%b state=%b out=%b",
                 $time, reset, in, DUT.ps_state, out);

        repeat (2) @(negedge clk);
        reset = 0;

        // Sequence 101
        @(negedge clk); in = 1;
        @(negedge clk); in = 0;
        @(negedge clk); in = 1;
        @(negedge clk); #1;
        if (out !== 1'b1) begin
            $display("FAIL: 101 not detected"); errors = errors + 1;
        end else $display("PASS: 101 detected");

        // Leave detection state
        @(negedge clk); in = 0; #1;
        if (out !== 1'b0) begin
            $display("FAIL: output did not clear"); errors = errors + 1;
        end else $display("PASS: output cleared");

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
