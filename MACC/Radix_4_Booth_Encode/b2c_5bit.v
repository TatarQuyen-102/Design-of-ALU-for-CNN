module b2c_5bit (
    input [4:0] B,  
    output [4:0] X   
);
    
    wire [1:0] AND_out; // Tín hiệu trung gian từ các cổng AND

    // Cổng NOT cho bit đầu tiên
    assign X[0] = ~B[0];  

    // Nhóm AND-3 và AND-4 theo cấu trúc 2-3-4
    assign AND_out[0] = B[0] & B[1] & B[2];   
    assign AND_out[1] = B[0] & B[1] & B[2] & B[3];       // 4-input AND

    // Tính toán các giá trị đầu ra X[i]
    assign X[1] = B[1] ^ B[0];
    assign X[2] = B[2] ^ (B[1] & B[0]);
    assign X[3] = B[3] ^ AND_out[0];
    assign X[4] = B[4] ^ AND_out[1];

endmodule