`timescale 1ns / 1ps

module parity_tb;
    reg  [3:0] data;
    reg  flip;               // 1 = inject a single-bit error on the parity line
    wire parity_tx, parity_rx, error;
    integer i, errors;

    parity_generator_4bit GEN(.data(data), .parity(parity_tx));
    assign parity_rx = parity_tx ^ flip;
    parity_checker_4bit CHK(.data(data), .parity_in(parity_rx), .error(error));

    initial begin
        errors = 0; flip = 0;
        $dumpfile("parity.vcd");
        $dumpvars(0, parity_tb);
        $monitor("t=%0t data=%b parity_tx=%b flip=%b parity_rx=%b error=%b",
                 $time, data, parity_tx, flip, parity_rx, error);

        for (i = 0; i < 16; i = i + 1) begin
            data = i; flip = 0; #5;               // error-free transmission
            if (parity_tx !== (^data) || error !== 1'b0) begin
                $display("FAIL (no error case): data=%b", data); errors = errors + 1;
            end
            flip = 1; #5;                         // corrupted parity bit
            if (error !== 1'b1) begin
                $display("FAIL (error not detected): data=%b", data); errors = errors + 1;
            end
        end

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
