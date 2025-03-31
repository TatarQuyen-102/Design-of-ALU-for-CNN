`timescale 1ns / 1ps

module Mul_tb;
    // Inputs
    reg signed [7:0] x;
    reg signed [7:0] y;
    
    // Output
    wire signed [14:0] o_mul;
    
    // Instantiate the Unit Under Test (UUT)
    Mul uut (
        .x(x),
        .y(y),
        .o_mul(o_mul)
    );
    
    initial begin
        $dumpfile("Mul_tb.vcd");
        $dumpvars(0, Mul_tb);
        
        /////////// stage 1 ///////////
        // $display("Testing 8-bit Multiplier using Booth Encoding");
        // $display("Time  |  x  |  y  | m_2x | o_s1_be | o_s1_mux3to1 | o_s1 ");
        // $monitor("%0t   | %b | %b | %b | %b | %b | %b", 
        //         $time, x[4:0], y[4:0],
        //         uut.m_2x , uut.o_s1_be, uut.o_s1_mux3to1, uut.o_s1);


        /////////// stage 2 ///////////
        // $display("Time  |  x  | m_2x | o_s2_mux3to1 | o_s1  | o_s2_be | o_s2 ");
        // $display("-----------------------------------------------------------");
        // $monitor("%0t   | %b | %b | %b | %b | %b | %b", 
        //         $time, x[4:0] , uut.m_2x , uut.o_s2_mux3to1, uut.o_s1[8:2], uut.o_s2_be, uut.o_s2);

        /////////// stage 3 ///////////
        // $display("Time  |  x  | m_2x | o_s3_mux3to1 | o_s2 | o_s3_be | o_s3 ");
        // $display("-----------------------------------------------------------");
        // $monitor("%0t   | %b | %b | %b | %b | %b | %b", 
        //         $time, x[4:0] , uut.m_2x , uut.o_s3_mux3to1, uut.o_s2[9:2], uut.o_s3_be, uut.o_s3);

        /////////// stage 4 ///////////
        // $display("Time  |  x  | m_2x | o_s4_mux3to1 | o_s3 | o_s4_be | o_s4 ");
        // $display("-----------------------------------------------------------");
        // $monitor("%0t   | %b | %b | %b | %b | %b | %b", 
        //         $time, x[4:0] , uut.m_2x , uut.o_s4_mux3to1, uut.o_s3[9:2], uut.o_s4_be, uut.o_s4);


        $monitor("%0t | %b(%d)| %b(%d)| %b(%d)", $time, x,x, y,y, o_mul, o_mul);
        
        // Apply test cases
        x = 8'b00000001; y = 8'b00000001; #10; // 1 * 1
        x = 8'b00000010; y = 8'b00000010; #10; // 2 * 2
        x = 8'b00001000; y = 8'b00000011; #10; // 8 * 3
        x = 8'b00001111; y = 8'b00001111; #10; // 15 * 15
        x = 8'b00111000; y = 8'b00011001; #10; // 56 * 25

        // Giá trị nhỏ
        x = 8'b00000000; y = 8'b00000000; #10; // 0 * 0
        x = 8'b00000001; y = 8'b00000000; #10; // 1 * 0
        x = 8'b00000000; y = 8'b00000001; #10; // 0 * 1
        x = 8'b00000001; y = 8'b00000001; #10; // 1 * 1
        
        // Giá trị lớn
        x = 8'b01111111; y = 8'b01111111; #10; // 127 * 127
        x = 8'b11111111; y = 8'b11111111; #10; // 255 * 255

        // Giá trị âm (bù 2)
        x = 8'b11111111; y = 8'b00000001; #10; // -1 * 1
        x = 8'b10000000; y = 8'b00000001; #10; // -128 * 1
        x = 8'b10000000; y = 8'b10000000; #10; // -128 * -128

        // Số đối xứng
        x = 8'b10101010; y = 8'b01010101; #10; // 170 * 85

        // Số chẵn - lẻ
        x = 8'b00000100; y = 8'b00000011; #10; // 4 * 3
        x = 8'b00001011; y = 8'b00000110; #10; // 11 * 6

        // Trường hợp biên
        x = 8'b00000001; y = 8'b11111111; #10; // 1 * 255
        x = 8'b11111111; y = 8'b00000001; #10; // -1 * 1
        x = 8'b11111111; y = 8'b11111111; #10; // -1 * -1
        
        $display("Test Completed");
        $finish;
    end
endmodule
