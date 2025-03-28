`timescale 1ns / 1ps

module tb_mod_bec;

reg signed  [8:0] B;   // Dữ liệu có dấu
wire signed [8:0] X;   // Đầu ra có dấu
wire signed [8:0] X_signed; // Biến trung gian

// Khởi tạo module mod_bec
mod_bec dut (.B(B), .X(X));

// Chuyển đổi giá trị signed
assign X_signed = X;

initial begin
    $dumpfile("mod_bec_tb.vcd");
    $dumpvars(0, tb_mod_bec);

    $display("Testing Modified BEC with Signed Values");
    $monitor("Time=%0t | B=%b (%0d) | X=%b (%0d, signed: %0d)", 
              $time, B, B, X, X, X_signed);

    // Test các giá trị dương
    B = 9'b000000000; #10;  // Expect X = 000000001
    B = 9'b000000001; #10;  // Expect X = 000000010
    B = 9'b000000010; #10;  // Expect X = 000000011

    // Test số âm (bit MSB = 1)
    B = 9'b111111110; #10;  // Expect X = 111111111 (-1)
    B = 9'b111111111; #10;  // Expect X = 000000000 (0)

    $display("TEST COMPLETED");
    $finish;
end

endmodule
