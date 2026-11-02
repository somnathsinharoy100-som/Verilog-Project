`timescale 1ns / 1ps

module lfsr_4bit_tb;
    reg clk, reset;
    wire [3:0] q;
    wire rand_bit;
    reg [3:0] seq [0:14];
    integer i, errors;

    lfsr_4bit DUT(.clk(clk), .reset(reset), .q(q), .rand_bit(rand_bit));
    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; errors = 0;
        seq[0]  = 4'b0001; seq[1]  = 4'b0010; seq[2]  = 4'b0100; seq[3]  = 4'b1001;
        seq[4]  = 4'b0011; seq[5]  = 4'b0110; seq[6]  = 4'b1101; seq[7]  = 4'b1010;
        seq[8]  = 4'b0101; seq[9]  = 4'b1011; seq[10] = 4'b0111; seq[11] = 4'b1111;
        seq[12] = 4'b1110; seq[13] = 4'b1100; seq[14] = 4'b1000;
        $dumpfile("lfsr_4bit.vcd");
        $dumpvars(0, lfsr_4bit_tb);
        $monitor("t=%0t reset=%b q=%b rand_bit=%b", $time, reset, q, rand_bit);

        repeat (2) @(negedge clk);
        reset = 0;

        // Check two full periods (the sequence repeats after 15 clocks)
        for (i = 0; i < 31; i = i + 1) begin
            #1;
            if (q !== seq[i % 15]) begin
                $display("FAIL: step %0d expected %b got %b", i, seq[i % 15], q);
                errors = errors + 1;
            end
            @(negedge clk);
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
