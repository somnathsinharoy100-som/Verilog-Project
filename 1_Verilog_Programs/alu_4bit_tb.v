`timescale 1ns / 1ps

module alu_4bit_tb;
    reg  [3:0] a, b;
    reg  [2:0] op;
    wire [3:0] result;
    wire carry, zero;
    integer errors;

    alu_4bit DUT(.a(a), .b(b), .op(op), .result(result), .carry(carry), .zero(zero));

    task check(input [3:0] exp_result, input exp_carry);
    begin
        #10;
        if (result !== exp_result || carry !== exp_carry) begin
            $display("FAIL: op=%b a=%b b=%b -> result=%b carry=%b (expected %b %b)",
                     op, a, b, result, carry, exp_result, exp_carry);
            errors = errors + 1;
        end else
            $display("PASS: op=%b a=%b b=%b -> result=%b carry=%b", op, a, b, result, carry);
    end
    endtask

    initial begin
        errors = 0;
        $dumpfile("alu_4bit.vcd");
        $dumpvars(0, alu_4bit_tb);
        $monitor("t=%0t op=%b a=%b b=%b result=%b carry=%b zero=%b",
                 $time, op, a, b, result, carry, zero);

        a = 4'b0110; b = 4'b0011;                          // a = 6, b = 3
        op = 3'b000; check(4'b1001, 1'b0);                 // ADD 6+3 = 9
        op = 3'b001; check(4'b0011, 1'b0);                 // SUB 6-3 = 3
        op = 3'b010; check(4'b0010, 1'b0);                 // AND
        op = 3'b011; check(4'b0111, 1'b0);                 // OR
        op = 3'b100; check(4'b0101, 1'b0);                 // XOR
        op = 3'b101; check(4'b1001, 1'b0);                 // NOT A
        op = 3'b110; check(4'b1100, 1'b0);                 // shift left
        op = 3'b111; check(4'b0011, 1'b0);                 // shift right

        a = 4'b1111; b = 4'b0001; op = 3'b000;             // ADD overflow: 15+1
        check(4'b0000, 1'b1);
        if (zero !== 1'b1) begin $display("FAIL: zero flag"); errors = errors + 1; end

        a = 4'b0011; b = 4'b0110; op = 3'b001;             // SUB with borrow: 3-6
        check(4'b1101, 1'b1);

        if (errors == 0) $display("ALL TESTS PASSED");
        else $display("TESTS FAILED: %0d", errors);
        $finish;
    end
endmodule
