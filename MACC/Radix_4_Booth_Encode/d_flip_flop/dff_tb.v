`timescale 1ns/1ps

module dff_tb;

    parameter N = 9;

    // Khai báo tín hiệu
    reg clk;
    reg rst_n;
    reg [N-1:0] d;
    wire [N-1:0] q;

    // Khởi tạo module D Flip-Flop
    dff #(N) dut (
        .clk(clk),
        .rst_n(rst_n),
        .d(d),
        .q(q)
    );

    // Tạo xung clock: chu kỳ 10ns
    always #5 clk = ~clk;

    initial begin
    $dumpfile("dff.vcd");
    $dumpvars(0, dff_tb); // dff_tb là tên module testbench
    end 


    initial begin
        $display("Time\tclk\trst_n\td\t\tq");
        $monitor("%0dns\t%b\t%b\t%h\t%h", $time, clk, rst_n, d, q);

        // Khởi tạo tín hiệu
        clk = 0;
        rst_n = 0;
        d = 0;

        // Giai đoạn reset
        #7 rst_n = 1;     // Hủy reset không đồng bộ

        // Nhập dữ liệu d và kiểm tra q cập nhật theo clock
        #3  d = 9'h1A3;   // Chờ tới cạnh lên clk
        #10 d = 9'h055;
        #10 d = 9'h0F0;

        // Reset bất đồng bộ giữa chừng
        #6  rst_n = 0;    // Reset khi clk đang ở giữa
        #10 rst_n = 1;    // Bỏ reset

        // Tiếp tục test sau reset
        #10 d = 9'h1E1;

        #10 $finish;
    end

endmodule
