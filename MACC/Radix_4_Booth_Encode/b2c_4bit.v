module b2c_4bit (
    input [3:0] B,  
    output [3:0] X   
);
    
    wire [3:0] B_not;

    assign B_not = ~B;

    assign X[0] = ~B_not[0];
    assign X[1] = B_not[1] ^ B_not[0];
    assign X[2] = B_not[2] ^ (B_not[1] & B_not[0]);
    assign X[3] = B_not[3] ^ (B_not[0] & B_not[1] & B_not[2]);

endmodule