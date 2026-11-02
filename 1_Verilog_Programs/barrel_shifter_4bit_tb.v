`timescale 1ns / 1ps

module barrel_shifter_4bit_tb;
    reg  [3:0] data;
    reg  [1:0] shamt, mode;
    wire [3:0] out;

    barrel_shifter_4bit DUT(.data(data), .shamt(shamt), .mode(mode), .out(out));

    initial begin
        $dumpfile("barrel_shifter.vcd");
        $dumpvars(0, barrel_shifter_4bit_tb);
        $monitor("t=%0t data=%b shamt=%d mode=%b out=%b",
                 $time, data, shamt, mode, out);

        data = 4'b1011; shamt = 2; mode = 0; #10;
        mode = 1; #10;
        mode = 2; #10;
        mode = 3; #10;
        shamt = 0; mode = 2; #10;
        $finish;
    end
endmodule
