module tb_b2c_5bit;
    reg [4:0] B;
    wire [4:0] X;
    
    // Kết nối với module b2c_5bit
    b2c_5bit uut (
        .B(B),
        .X(X)
    );
    
    initial begin
        $dumpfile("tb_b2c_5bit.vcd");
        $dumpvars(0, tb_b2c_5bit);
        
        // Kiểm tra tất cả các giá trị có thể của B
        B = 5'b00000; #10;
        B = 5'b00001; #10;
        B = 5'b00010; #10;
        B = 5'b00011; #10;
        B = 5'b00100; #10;
        B = 5'b00101; #10;
        B = 5'b00110; #10;
        B = 5'b00111; #10;
        B = 5'b01000; #10;
        B = 5'b01001; #10;
        B = 5'b01010; #10;
        B = 5'b01011; #10;
        B = 5'b01100; #10;
        B = 5'b01101; #10;
        B = 5'b01110; #10;
        B = 5'b01111; #10;
        B = 5'b10000; #10;
        B = 5'b10001; #10;
        B = 5'b10010; #10;
        B = 5'b10011; #10;
        B = 5'b10100; #10;
        B = 5'b10101; #10;
        B = 5'b10110; #10;
        B = 5'b10111; #10;
        B = 5'b11000; #10;
        B = 5'b11001; #10;
        B = 5'b11010; #10;
        B = 5'b11011; #10;
        B = 5'b11100; #10;
        B = 5'b11101; #10;
        B = 5'b11110; #10;
        B = 5'b11111; #10;
        
        $finish;
    end
    
    initial begin
        $display("Time     |    B   |   X   ");
        $monitor("%0t | B = %b(%d)| X = %b", $time, B,B, X);
    end
endmodule
