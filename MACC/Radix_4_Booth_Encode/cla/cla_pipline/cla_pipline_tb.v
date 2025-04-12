`timescale 1ns / 1ps

module cla_tb;

    parameter N = 16;

    reg clk;
    reg [N-1:0] A, B;
    reg Cin;
    wire [N-1:0] Sum;
    wire Cout;

    // Biến để hiển thị số thập phân có dấu
    wire signed [N-1:0] As = A;
    wire signed [N-1:0] Bs = B;
    wire signed [N-1:0] Ss = Sum;

    // Instantiate CLA
    cla #(N) cla_inst (
        .clk(clk),
        .A(A),
        .B(B),
        .Cin(Cin),
        .Sum(Sum),
        .Cout(Cout)
    );

    // Clock generation: 10ns period
    initial clk = 0;
    always #5 clk = ~clk;

    // Dump waveform
    initial begin
        $dumpfile("tb_cla_pipeline.vcd");
        $dumpvars(0, cla_tb);
    end

    // Hiển thị tiêu đề và giám sát kết quả
    initial begin
        $display("Time | Cin |         A         |         B         |         Sum         | Cout");
        $monitor("%4t |  %b  | %b (%0d) | %b (%0d) | %b (%0d) |  %b", 
                 $time, Cin, A, As, B, Bs, Sum, Ss, Cout);
    end

    // Test vectors
    initial begin
        // Đợi 1 chút để ổn định mô phỏng
        #1;

        A = 16'd10;         B = 16'd20;        Cin = 0; #20;
        A = 16'd1234;       B = 16'd4321;      Cin = 0; #20;

        A = -16'sd15;       B = 16'd5;         Cin = 1; #20;  // A - B
        A = -16'sd100;      B = 16'd50;        Cin = 0; #20;

        A = 16'd30;         B = -16'sd10;      Cin = 0; #20;
        A = 16'd5;          B = -16'sd8;       Cin = 1; #20;

        A = -16'sd25;       B = -16'sd15;      Cin = 1; #20;

        A = 16'sd32767;     B = 16'sd1;        Cin = 0; #20;
        A = -16'sd32768;    B = -16'sd1;       Cin = 0; #20;

        #20;
        $finish;
    end

endmodule
