`timescale 1ns / 1ps

module tb_sqrt_csa_rsa;
    reg  [8:0] A, B;
    reg  Cin;
    wire [9:0] Out;

    // Khởi tạo module DUT (Device Under Test)
    sqrt_csa_rsa dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Out(Out)
    );

    // Ghi waveform vào file .vcd để phân tích
    initial begin
        $dumpfile("tb_sqrt_csa_rsa.vcd");
        $dumpvars(0, tb_sqrt_csa_rsa);
    end

    // Hiển thị kết quả trên terminal
    initial begin
        $display("Time  | Cin |      A      |      B      |       Out");
        $display("------------------------------------------------------");
        $monitor("%5t |  %b  | %9b (%4d) | %9b (%4d) | %10b (%4d)", 
                 $time, Cin, A, A, B, B, Out, Out);
    end

    // Các trường hợp kiểm tra
    initial begin
        A = 9'b000000001; B = 9'b000000001; Cin = 0; #10;  // 1 + 1 = 2
        A = 9'b000000010; B = 9'b000000011; Cin = 0; #10;  // 2 + 3 = 5
        A = 9'b000000111; B = 9'b000000011; Cin = 0; #10;  // 7 + 3 = 10
        A = 9'b000000100; B = 9'b000000011; Cin = 1; #10;  // 4 - 3 = 1
        A = 9'b000010000; B = 9'b000001000; Cin = 1; #10;  // 8 - 8 = 0
        A = 9'b111111111; B = 9'b000000001; Cin = 0; #10;  // Tràn số 511 + 1
        A = 9'b000000000; B = 9'b000000001; Cin = 1; #10;  // 0 - 1 = -1 (bù 2)
        A = 9'b001001001; B = 9'b000110110; Cin = 0; #10;  // Kiểm tra số bất kỳ

        A = 9'b000000001; B = 9'b000000001; Cin = 1; #10; // 1 * 1
        A = 9'b000000010; B = 9'b000000010; Cin = 1; #10; // 2 * 2
        A = 9'b000001000; B = 9'b000000011; Cin = 0; #10; // 8 * 3
        A = 9'b000001111; B = 9'b000001111; Cin = 1; #10; // 15 * 15
        A = 9'b000111000; B = 9'b000011001; Cin = 1; #10; // 56 * 25

        $finish;
    end
endmodule
