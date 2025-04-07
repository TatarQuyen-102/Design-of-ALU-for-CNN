`timescale 1ns / 1ps

module Mul_reg_tb;
    // Inputs
    reg clk;
    reg rst_n;
    reg signed [7:0] x;
    reg signed [7:0] y;
    
    // Output
    wire signed [14:0] o_mul;
    
    // Instantiate the Unit Under Test (UUT)
    Mul_reg uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y),
        .o_mul(o_mul)
    );

    // Tạo xung clock: chu kỳ 10ns
    always #5 clk = ~clk;
    
    initial begin
        $dumpfile("Mul_reg_tb.vcd");
        $dumpvars(0, Mul_reg_tb);
    end

    initial begin
        $monitor("%0t | %b(%d)| %b(%d)| %b(%d)", $time, x,x, y,y, o_mul, o_mul);

        clk = 0;
        rst_n = 0;

        #7 rst_n = 1;
        
        // Apply test cases
        x = 8'b00000001; y = 8'b00000001; #10; // 1 * 1
        x = 8'b00000010; y = 8'b00000010; #10; // 2 * 2
        x = 8'b00001000; y = 8'b00000011; #10; // 8 * 3
        x = 8'b00001111; y = 8'b00001111; #10; // 15 * 15
        x = 8'b00111000; y = 8'b00011001; #10; // 56 * 25

        // Small values
        x = 8'b00000000; y = 8'b00000000; #10; // 0 * 0
        x = 8'b00000001; y = 8'b00000000; #10; // 1 * 0
        x = 8'b00000000; y = 8'b00000001; #10; // 0 * 1
        x = 8'b00000001; y = 8'b00000001; #10; // 1 * 1
    
        // Large values
        x = 8'b01111111; y = 8'b01111111; #10; // 127 * 127
        x = 8'b11111111; y = 8'b11111111; #10; // 255 * 255

        // Negative values (two’s complement)
        x = 8'b11111111; y = 8'b00000001; #10; // -1 * 1
        x = 8'b10000000; y = 8'b00000001; #10; // -128 * 1
        x = 8'b10000000; y = 8'b10000000; #10; // -128 * -128

        // Symmetric values
        x = 8'b10101010; y = 8'b01010101; #10; // 170 * 85

        // Odd and even numbers
        x = 8'b00000100; y = 8'b00000011; #10; // 4 * 3
        x = 8'b00001011; y = 8'b00000110; #10; // 11 * 6

        // Boundary cases
        x = 8'b00000001; y = 8'b11111111; #10; // 1 * 255
        x = 8'b11111111; y = 8'b00000001; #10; // -1 * 1
        x = 8'b11111111; y = 8'b11111111; #10; // -1 * -1
        
        $display("Test Completed");
        $finish;
    end
endmodule
