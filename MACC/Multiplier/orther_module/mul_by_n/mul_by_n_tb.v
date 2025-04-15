`timescale 1ns / 1ps

module tb_multiplier_by_n;

// Testbench parameters
parameter N = 8;  // Độ rộng dữ liệu đầu vào
parameter S = 1;  // Số bit dịch trái

// Declare testbench signals
reg  [N-1:0] A;
wire [N:0]   Y;

// Instantiate the multiplier_by_n module
multiplier_by_n #(.N(N), .S(S)) dut (.A(A), .Y(Y));

// Apply test stimulus
initial begin
    $dumpfile("multiplier_by_n_tb.vcd"); // Ghi dạng sóng vào file VCD
    $dumpvars(0, tb_multiplier_by_n);

    $display("Testing Multiplier by N (Shift Left by %d)", S);
    $monitor("Time=%0t | A=%b (%0d) | Y=%b (%0d)", $time, A, A, Y, Y);

    // Apply various test cases
    A = 8'b00000001; #10; // Expect Y = A << S
    A = 8'b00000010; #10; // Expect Y = A << S
    A = 8'b00000100; #10; // Expect Y = A << S
    A = 8'b10000000; #10; // Expect sign extension
    A = 8'b11111111; #10; // Expect sign extension with negative values
    A = 8'b01010101; #10; // Test random pattern
    A = 8'b10101010; #10; // Test another pattern

    $display("TEST COMPLETED");
    $finish;
end

endmodule
