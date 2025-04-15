`timescale 1ns / 1ps

module tb_rsa;
    parameter N = 8;

    // Khai báo tín hiệu testbench
    reg  [N-1:0] A, B;
    reg  Cin;
    wire [N-1:0] Sum;
    wire Cout;

    // Khởi tạo module DUT (Device Under Test)
    rsa #(N) dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Ghi tín hiệu vào file .vcd để xem waveform
    initial begin
        $dumpfile("tb_rsa.vcd");
        $dumpvars(0, tb_rsa);
    end

    // Hiển thị kết quả đầu ra
    initial begin
        $display("Time  | Cin | A        | B         | Sum   | Cout");
        $monitor("%5t |  %b  | %b (%d)| %b (%d)|  %b  (%d)|  %b", $time, Cin, A, A, B, B, Sum, Sum, Cout);
    end

    // Test các trường hợp
    initial begin
        // Trường hợp cộng A + B
        // A = 4'b0011; B = 4'b0001; Cin = 0; #10; // 3 + 1 = 4
        // A = 4'b0110; B = 4'b0011; Cin = 0; #10; // 6 + 3 = 9
        // A = 4'b1111; B = 4'b0001; Cin = 0; #10; // 15 + 1 = 0 (tràn số)

        // // Trường hợp trừ A - B
        // A = 4'b0100; B = 4'b0011; Cin = 1; #10; // 4 - 3 = 1
        // A = 4'b1000; B = 4'b0100; Cin = 1; #10; // 8 - 4 = 4
        // A = 4'b0000; B = 4'b0001; Cin = 1; #10; // 0 - 1 = 1111 (dưới 0 do tràn số)
        // A = 4'b1010; B = 4'b1001; Cin = 1; #10; // 10 - 9 = 1
        // A = 4'b1000; B = 4'b1100; Cin = 1; #10; // 8 - 12 = -4 (1_1100)
        // A = 4'b0000; B = 4'b0000; Cin = 1; #10; // 0 - 0 = ?

        A = 8'b00000001; B = 8'b00000001; Cin = 1; #10; // 1 * 1
        A = 8'b00000010; B = 8'b00000010; Cin = 1; #10; // 2 * 2
        A = 8'b00001000; B = 8'b00000011; Cin = 1; #10; // 8 * 3
        A = 8'b00001111; B = 8'b00001111; Cin = 1; #10; // 15 * 15
        A = 8'b00111000; B = 8'b00011001; Cin = 1; #10; // 56 * 25 
        A = 8'b00000001; B = 8'b00001111; Cin = 0; #10; // 56 * 25  

        $finish;
    end
endmodule
