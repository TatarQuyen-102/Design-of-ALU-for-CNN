// Verilog Code cho 10-bit Modified BEC
module mod_bec (
    input [8:0] B,   // Đầu vào 10-bit
    output [8:0] X   // Đầu ra 10-bit (B + 1)
);
    
    wire [5:0] AND_out; // Tín hiệu trung gian từ các cổng AND
    
    // Cổng NOT cho bit đầu tiên
    assign X[0] = ~B[0];  

    // Nhóm AND-3 và AND-4 theo cấu trúc 2-3-4
    assign AND_out[0] = B[0] & B[1] & B[2];              // 3-input AND
    assign AND_out[1] = B[0] & B[1] & B[2] & B[3];       // 4-input AND
    assign AND_out[2] = B[4] & AND_out[1];               // AND với giá trị trước đó
    assign AND_out[3] = B[5] & B[4] & AND_out[1];        // 3-input AND
    assign AND_out[4] = AND_out[1] & B[6] & B[5] & B[4]; // 4-input AND
    assign AND_out[5] = B[7] & AND_out[4];               // AND với giá trị trước đó
//    assign AND_out[6] = B[8] & B[7] & AND_out[4];        // 3-input AND
//    assign AND_out[7] = B[9] & B[8] & B[7] & AND_out[4]; // 4-input AND

    // Tính toán các giá trị đầu ra X[i]
    assign X[1] = B[1] ^ B[0];
    assign X[2] = B[2] ^ (B[1] & B[0]);
    assign X[3] = B[3] ^ AND_out[0];
    assign X[4] = B[4] ^ AND_out[1];
    assign X[5] = B[5] ^ AND_out[2];
    assign X[6] = B[6] ^ AND_out[3];
    assign X[7] = B[7] ^ AND_out[4];
    assign X[8] = B[8] ^ AND_out[5];
//    assign X[9] = B[9] ^ AND_out[6];

endmodule
