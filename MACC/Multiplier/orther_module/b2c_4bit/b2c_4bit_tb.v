module tb_b2c_4bit;
    reg [3:0] B;
    wire [3:0] X;
    
    // Kết nối với module b2c_4bit
    b2c_4bit uut (
        .B(B),
        .X(X)
    );
    
    initial begin
        $dumpfile("tb_b2c_4bit.vcd");
        $dumpvars(0, tb_b2c_4bit);
        
        // Kiểm tra tất cả các giá trị có thể của B
        B = 4'b0000; #10;
        B = 4'b0001; #10;
        B = 4'b0010; #10;
        B = 4'b0011; #10;
        B = 4'b0100; #10;
        B = 4'b0101; #10;
        B = 4'b0110; #10;
        B = 4'b0111; #10;
        B = 4'b1000; #10;
        B = 4'b1001; #10;
        B = 4'b1010; #10;
        B = 4'b1011; #10;
        B = 4'b1100; #10;
        B = 4'b1101; #10;
        B = 4'b1110; #10;
        B = 4'b1111; #10;
        
        $finish;
    end
    
    initial begin
        $monitor("Time = %0t | B = %b | X = %b", $time, B, X);
    end
endmodule
