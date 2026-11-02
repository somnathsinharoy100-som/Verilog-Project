`timescale 1ns / 1ps

module comparator_4bit_tb;
    reg  [3:0] a, b;
    wire gt, eq, lt;
    integer i, j, errors;

    comparator_4bit DUT(.a(a), .b(b), .gt(gt), .eq(eq), .lt(lt));

    initial begin
        errors = 0;
        $dumpfile("comparator_4bit.vcd");
        $dumpvars(0, comparator_4bit_tb);
        $monitor("t=%0t a=%d b=%d gt=%b eq=%b lt=%b", $time, a, b, gt, eq, lt);

        // Exhaustive test: all 16 x 16 input combinations
        for (i = 0; i < 16; i = i + 1) begin
            for (j = 0; j < 16; j = j + 1) begin
                a = i; b = j; #5;
                if (gt !== (i > j) || eq !== (i == j) || lt !== (i < j)) begin
                    $display("FAIL: a=%0d b=%0d gt=%b eq=%b lt=%b", i, j, gt, eq, lt);
                    errors = errors + 1;
                end
            end
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
