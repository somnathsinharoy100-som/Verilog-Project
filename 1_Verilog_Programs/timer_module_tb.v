`timescale 1ns / 1ps

module timer_module_tb;
    reg clk, reset, start;
    reg [3:0] load_val;
    wire [3:0] remaining;
    wire running, done;
    integer errors;

    timer_module DUT(.clk(clk), .reset(reset), .start(start), .load_val(load_val),
                     .remaining(remaining), .running(running), .done(done));

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; start = 0; load_val = 0; errors = 0;
        $dumpfile("timer_module.vcd");
        $dumpvars(0, timer_module_tb);
        $monitor("t=%0t reset=%b start=%b load=%0d remaining=%0d running=%b done=%b",
                 $time, reset, start, load_val, remaining, running, done);

        repeat (2) @(negedge clk);
        reset = 0;

        // Test 1: 3-cycle timer
        load_val = 4'd3; start = 1; @(negedge clk);
        start = 0;
        repeat (2) @(negedge clk); #1;
        if (done !== 1'b0 || remaining !== 4'd1) begin
            $display("FAIL: timer expired early"); errors = errors + 1;
        end
        @(negedge clk); #1;
        if (done !== 1'b1 || remaining !== 4'd0) begin
            $display("FAIL: done not asserted after 3 cycles"); errors = errors + 1;
        end else $display("PASS: 3-cycle timer");
        @(negedge clk); #1;
        if (done !== 1'b0) begin
            $display("FAIL: done pulse longer than one cycle"); errors = errors + 1;
        end

        // Test 2: 1-cycle timer
        load_val = 4'd1; start = 1; @(negedge clk);
        start = 0; @(negedge clk); #1;
        if (done !== 1'b1) begin
            $display("FAIL: 1-cycle timer"); errors = errors + 1;
        end else $display("PASS: 1-cycle timer");

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
