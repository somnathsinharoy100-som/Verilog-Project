`timescale 1ns / 1ps

module universal_shift_reg_tb;
    reg clk, reset;
    reg [1:0] mode;
    reg serial_in;
    reg [3:0] parallel_in;
    wire [3:0] Q;
    wire serial_out;

    universal_shift_reg_4bit DUT(
        .clk(clk), .reset(reset), .mode(mode),
        .serial_in(serial_in), .parallel_in(parallel_in),
        .Q(Q), .serial_out(serial_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0; reset = 1; mode = 0; serial_in = 0; parallel_in = 0;
        $dumpfile("universal_shift_reg.vcd");
        $dumpvars(0, universal_shift_reg_tb);
        $monitor("t=%0t reset=%b mode=%b serial_in=%b parallel=%b Q=%b serial_out=%b",
                 $time, reset, mode, serial_in, parallel_in, Q, serial_out);

        repeat (2) @(negedge clk);
        reset = 0;

        mode = 2'b11; parallel_in = 4'b1011; @(negedge clk);   // load 1011
        mode = 2'b00;                        @(negedge clk);   // hold 1011
        mode = 2'b01; serial_in = 1;         @(negedge clk);   // right -> 1101
        mode = 2'b10; serial_in = 0;         @(negedge clk);   // left  -> 1010
        mode = 2'b11; parallel_in = 4'b0100; @(negedge clk);   // load 0100
        mode = 2'b00;                        @(negedge clk);   // hold 0100
        $finish;
    end
endmodule
