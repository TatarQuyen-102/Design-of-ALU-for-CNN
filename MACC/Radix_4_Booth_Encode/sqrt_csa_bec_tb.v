module tb_sqrt_csa_bec;
    reg [8:0] A, B;
    reg Cin;
    wire [9:0] Out;

    // Kết nối với module sqrt_csa_bec
    sqrt_csa_bec uut (
        .A(A),
        .B(B),
        .Cin(Cin),
        .Out(Out)
    );

    initial begin
        $dumpfile("tb_sqrt_csa_bec.vcd");
        $dumpvars(0, tb_sqrt_csa_bec);
        
        A = 9'b000000000; B = 9'b000000000; Cin = 0; #10;
        A = 9'b000000001; B = 9'b000000001; Cin = 0; #10;
        A = 9'b000000010; B = 9'b000000011; Cin = 0; #10;
        A = 9'b000001100; B = 9'b000001001; Cin = 0; #10;
        A = 9'b000011110; B = 9'b000011011; Cin = 0; #10; 
        A = 9'b000000000; B = 9'b000000000; Cin = 0; #10; 
        A = 9'b011111111;  B = 9'b011111111; Cin = 1; #10; 
        A = 9'b001110011;  B = 9'b010011101;  Cin = 1;  #10;  
        A = 9'b010001011;  B = 9'b011110100;  Cin = 1;  #10;  
        A = 9'b000101001;  B = 9'b001010101;  Cin = 1;  #10;  
        A = 9'b011011110;  B = 9'b000011010;  Cin = 1;  #10; 
        $finish;
    end
    
    initial begin
        $display("Time |  A        |  B             |  Cin |   Out ");
        $monitor("%0t | %b(%d) | %b(%d) | %b | %b(%d)", 
                 $time, A,A, B,B, Cin, Out,Out);

        // Test rca
        // $display("Time| Cin | A[1:0]| B[1:0]| o_rsa_2bit| A[4:2]| B[4:2] | o_rsa_3bit_add | o_rsa_3bit_sub | A[8:5] | B[8:5] | o_rsa_4bit_add| o_rsa_4bit_sub");
        // $monitor("%0t   | %b  | %b      | %b    | %b        | %b | %b   | %b            | %b            | %b    | %b    | %b          | %b             ", 
        //          $time, Cin, A[1:0],B[1:0],uut.o_rsa_2bit, A[4:2], B[4:2], uut.o_rsa_3bit_add,uut.o_rsa_3bit_sub,A[8:5] , B[8:5] , uut.o_rsa_4bit_add, uut.o_rsa_4bit_sub);
    end
endmodule
