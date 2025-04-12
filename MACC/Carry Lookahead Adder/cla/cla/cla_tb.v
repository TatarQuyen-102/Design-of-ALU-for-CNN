`timescale 1ns / 1ps

module tb_cla_nbit;
    parameter N = 16;

    // Tín hiệu gốc
    reg  [N-1:0] A, B;
    reg          Cin;
    wire [N-1:0] Sum;
    wire         Cout;

    // Tín hiệu có dấu để hiển thị đúng số âm
    wire signed [N-1:0] As, Bs, Ss;

    assign As = A;
    assign Bs = B;
    assign Ss = Sum;

    // Khởi tạo module DUT
    cla #(N) dut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Ghi tín hiệu vào file .vcd để xem waveform
    initial begin
        $dumpfile("tb_cla_nbit.vcd");
        $dumpvars(0, tb_cla_nbit);
    end

    // Hiển thị kết quả đầu ra
    initial begin
        $display("Time  | Cin |         A         |         B         |         Sum         | Cout");
        $monitor("%5t |  %b  | %b (%0d) | %b (%0d) | %b (%0d) |  %b", 
                  $time, Cin, A, As, B, Bs, Sum, Ss, Cout);
    end

    // Các test vector
    initial begin
        A = 16'd10; B = 16'd20; Cin = 0; #10;
        A = 16'd1234; B = 16'd4321; Cin = 0; #10;

        A = -16'sd15; B = 16'd5; Cin = 1; #10;
        A = -16'sd100; B = 16'd50; Cin = 0; #10;

        A = 16'd30; B = -16'sd10; Cin = 0; #10;
        A = 16'd5; B = -16'sd8; Cin = 1; #10;

        A = -16'sd25; B = -16'sd15; Cin = 1; #10;

        A = 16'sd32767; B = 16'sd1; Cin = 0; #10;
        A = -16'sd32768; B = -16'sd1; Cin = 0; #10;

        $finish;
    end
endmodule
