`timescale 1ns / 1ps

module async_counter_tb;
    reg clk, reset;
    wire [3:0] q;
    integer i, errors;

    async_counter DUT(.clk(clk), .reset(reset), .q(q));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; errors = 0;
        $dumpfile("async_counter.vcd");
        $dumpvars(0, async_counter_tb);
        $monitor("t=%0t reset=%b q=%b (%0d)", $time, reset, q, q);

        #12 reset = 0;                         // release between clock edges

        // Count must increase by 1 on every falling clock edge (wraps after 15)
        for (i = 1; i <= 20; i = i + 1) begin
            @(negedge clk); #1;                // allow the ripple to settle
            if (q !== i[3:0]) begin
                $display("FAIL: expected %0d got %0d", i[3:0], q); errors = errors + 1;
            end
        end

        // Asynchronous reset: clears immediately, without waiting for a clock edge
        #2 reset = 1; #1;
        if (q !== 4'b0000) begin
            $display("FAIL: async reset"); errors = errors + 1;
        end else $display("PASS: asynchronous reset");

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
