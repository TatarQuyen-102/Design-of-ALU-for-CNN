`timescale 1ns/1ps

module sqrt_csa_rsa_tb;

    // Khai báo tín hiệu đầu vào và đầu ra
    reg [8:0] A, B;
    reg Cin;
    wire [9:0] Out;

    // Gọi module sqrt_csa_rsa
    sqrt_csa_rsa UUT (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Out(Out)
    );

    // Ghi dữ liệu mô phỏng vào file VCD
    initial begin
        $dumpfile("sqrt_csa_rsa_tb.vcd");
        $dumpvars(0, sqrt_csa_rsa_tb);

        $display("Time    | A (Bit) | B (Bit) | Cin | o_rsa_2bit | o_rsa_3bit_add | o_rsa_3bit_sub | o_rsa_3bit | o_rsa_4bit_add | o_rsa_4bit_sub | o_rsa_4bit | Out (Dec)");
        $display("------------------------------------------------------------------");

        $monitor("%4t | %b | %b | %b | %b | %b | %b | %b | %b | %b | %b |  %b(%d)", 
                 $time, A, B, Cin, 
                 UUT.o_rsa_2bit, UUT.o_rsa_3bit_add ,UUT.o_rsa_3bit_sub ,UUT.o_rsa_3bit, UUT.o_rsa_4bit_add ,UUT.o_rsa_4bit_sub ,UUT.o_rsa_4bit, Out, Out);

        A = 9'b000110011;  B = 9'b000011101;  Cin = 0;  #10;  // A = 51, B = 29  (Cộng)
        A = 9'b111001110;  B = 9'b000001100;  Cin = 1;  #10;  // A = -26, B = 6  (Trừ)
        A = 9'b000000101;  B = 9'b111110101;  Cin = 0;  #10;  // A = 5, B = -11   (Cộng)
        A = 9'b111101000;  B = 9'b000000011;  Cin = 1;  #10;  // A = -8, B = 3    (Trừ)
        A = 9'b000100100;  B = 9'b000011011;  Cin = 0;  #10;  // A = 36, B = 27   (Cộng)
        A = 9'b111000101;  B = 9'b111100010;  Cin = 1;  #10;  // A = -27, B = -14 (Trừ)
        A = 9'b000011111;  B = 9'b000001000;  Cin = 0;  #10;  // A = 15, B = 8    (Cộng)
        A = 9'b000100101;  B = 9'b000010010;  Cin = 1;  #10;  // A = 37, B = 18   (Trừ)
        A = 9'b111010001;  B = 9'b000010110;  Cin = 0;  #10;  // A = -23, B = 22  (Cộng)
        A = 9'b000000110;  B = 9'b000000011;  Cin = 1;  #10;  // A = 6, B = 3     (Trừ)
        A = 9'b101110011;  B = 9'b110011101;  Cin = 0;  #10;  // A = -77, B = -51  (Cộng)
        A = 9'b110001011;  B = 9'b011110100;  Cin = 1;  #10;  // A = -53, B =  60  (Trừ)
        A = 9'b100101001;  B = 9'b001010101;  Cin = 0;  #10;  // A = -87, B =  21  (Cộng)
        A = 9'b111011110;  B = 9'b000011010;  Cin = 1;  #10;  // A = -18, B =  10  (Trừ)
        A = 9'b010101010;  B = 9'b101011011;  Cin = 0;  #10;  // A = 170, B = -85  (Cộng)

        $finish;
    end
endmodule
