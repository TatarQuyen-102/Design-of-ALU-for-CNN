module b2c_4bit (
    input [3:0] B,  
    output [3:0] X   
);

    assign X[0] = ~B[0];
    assign X[1] = B[1] ^ B[0];
    assign X[2] = B[2] ^ (B[1] & B[0]);
    assign X[3] = B[3] ^ (B[0] & B[1] & B[2]);

endmodule