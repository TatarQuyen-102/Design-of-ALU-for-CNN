module cla_nbit #(
    parameter N = 16  // Tổng số bit, phải là bội số của 4
)(
    input  [N-1:0] A, B,
    input         Cin,
    output [N-1:0] S,
    output        Cout
);
    localparam NUM_BLOCKS = N / 4;

    wire [NUM_BLOCKS-1:0] carry;

    genvar i;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : cla_block
            cla_4bit cla_inst (
                .A(A[i*4 + 3 : i*4]),
                .B(B[i*4 + 3 : i*4]),
                .Cin((i == 0) ? Cin : carry[i-1]),
                .S(S[i*4 + 3 : i*4]),
                .Cout(carry[i])
            );
        end
    endgenerate

    assign Cout = carry[NUM_BLOCKS-1];
endmodule


// 4_bit_CLA
module cla_4bit(
    input [3:0] A, B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire G[3:0], P[3:0];
    wire C[4:0];

    assign G[0] = A[0] & B[0];
    assign G[1] = A[1] & B[1];
    assign G[2] = A[2] & B[2];
    assign G[3] = A[3] & B[3];

    assign P[0] = A[0] ^ B[0];
    assign P[1] = A[1] ^ B[1];
    assign P[2] = A[2] ^ B[2];
    assign P[3] = A[3] ^ B[3];
    
    assign C[0] = Cin;
    assign C[1] = G[0] | (P[0] & Cin);
    assign C[2] = G[1] | (P[1] & (G[0] | (P[0] & Cin)));
    assign C[3] = G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))));
    assign Cout = G[3] | (P[3] & (G[2] | (P[2] & (G[1] | (P[1] & (G[0] | (P[0] & Cin)))))));

    assign S[0] = P[0] ^ C[0];
    assign S[1] = P[1] ^ C[1];
    assign S[2] = P[2] ^ C[2];
    assign S[3] = P[3] ^ C[3];
   
endmodule
