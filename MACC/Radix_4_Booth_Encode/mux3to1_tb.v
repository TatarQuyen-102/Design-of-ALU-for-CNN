`timescale 1ns / 1ps

module tb_mux3to1;

// Tham số
parameter N = 9;

// Tín hiệu thử nghiệm
reg  [N-1:0] A, B, C;  // Đầu vào của MUX
reg  S0, S1;           // Chọn tín hiệu
wire [N-1:0] Out;      // Đầu ra của MUX

// Khởi tạo module cần test
mux3to1 #(N) uut (
    .A(A), .B(B), .C(C),
    .S0(S0), .S1(S1),
    .Out(Out)
);

// Tạo file VCD để quan sát trên GTKWave
initial begin
    $dumpfile("mux3to1_tb.vcd");
    $dumpvars(0, tb_mux3to1);
end

// Kiểm tra nhiều trường hợp khác nhau
initial begin
    $display("Time=%0t | S1 S0 | A  B  C  | Out", $time);
    $monitor("Time=%0t | %b  %b  | %d %d %d | %d", $time, S1, S0, A, B, C, Out);
    
    // Khởi tạo các đầu vào
    A = 9'b000000001; B = 9'b000000010; C = 9'b000000100;
    
    // Thử nghiệm các giá trị chọn S1 S0
    S1 = 0; S0 = 0; #10; // Chọn A
    S1 = 0; S0 = 1; #10; // Chọn B
    S1 = 1; S0 = 0; #10; // Chọn C
    S1 = 1; S0 = 1; #10; // Trường hợp mặc định (0)

    $finish;
end

endmodule
