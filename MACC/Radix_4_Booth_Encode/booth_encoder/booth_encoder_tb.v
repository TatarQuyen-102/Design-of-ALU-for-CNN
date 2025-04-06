`timescale 1ns / 1ps

module booth_encoder_tb;
    // Khai báo tín hiệu đầu vào (reg) và đầu ra (wire)
    reg B0, B1, B2;
    wire P0, P1, P2;

    // Kết nối module cần test (DUT - Device Under Test)
    booth_encoder dut (
        .B0(B0), 
        .B1(B1), 
        .B2(B2),  
        .P0(P0), 
        .P1(P1), 
        .P2(P2)
    );

    // Tạo tín hiệu kiểm tra
    initial begin
        $dumpfile("tb_booth_encoder.vcd"); // Lưu VCD để xem trên GTKWave
        $dumpvars(0, booth_encoder_tb);

        $display("Testing Booth Encoder...");
        $monitor("Time=%0t | B=%b%b%b | P=%b%b%b", $time, B2, B1, B0, P2, P1, P0);

        // Thử tất cả 8 tổ hợp đầu vào (B2, B1, B0)
        B2 = 0; B1 = 0; B0 = 0; #1;
        B2 = 0; B1 = 0; B0 = 1; #1;
        B2 = 0; B1 = 1; B0 = 0; #1;
        B2 = 0; B1 = 1; B0 = 1; #1;
        B2 = 1; B1 = 0; B0 = 0; #1;
        B2 = 1; B1 = 0; B0 = 1; #1;
        B2 = 1; B1 = 1; B0 = 0; #1;
        B2 = 1; B1 = 1; B0 = 1; #1;

        $display("Test Completed!");
        $finish;
    end

endmodule
