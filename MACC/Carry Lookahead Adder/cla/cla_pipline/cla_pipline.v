module cla #(
    parameter N = 16
)(
    input              clk,
    input  [N-1:0]     A, B,
    input              Cin,
    output reg [N-1:0] Sum,
    output reg         Cout
);
    localparam NUM_BLOCKS = N / 4;

    // Thanh ghi để lưu input sau khi qua DFF
    reg [N-1:0] A_reg, B_reg;
    reg         Cin_reg;

    // Output tạm thời (combinational)
    wire [N-1:0] Sum_comb;
    wire         Cout_comb;

    // Các wire phụ trợ
    wire [NUM_BLOCKS-1:0] carry;
    wire [N-1:0] B_xor;

    // Chốt input vào các thanh ghi
    always @(posedge clk) begin
        A_reg   <= A;
        B_reg   <= B;
        Cin_reg <= Cin;
    end

    // Tính toán B xor Cin
    assign B_xor = B_reg ^ {N{Cin_reg}};

    // Mạch tính toán CLA theo block 4-bit
    genvar i;
    generate
        for (i = 0; i < NUM_BLOCKS; i = i + 1) begin : cla_block
            cla_4bit cla_inst (
                .A   (A_reg[i*4 + 3 : i*4]),
                .B   (B_xor[i*4 + 3 : i*4]),
                .Cin ((i == 0) ? Cin_reg : carry[i-1]),
                .Sum (Sum_comb[i*4 + 3 : i*4]),
                .Cout(carry[i])
            );
        end
    endgenerate

    // Tính carry_sign và Cout combinational
    wire carry_sign = carry[NUM_BLOCKS-1];
    assign Cout_comb = carry_sign ^ Cin_reg;  // Xử lý bit có dấu khi trừ

    // Chốt output sau khi tính toán xong
    always @(posedge clk) begin
        Sum  <= Sum_comb;
        Cout <= Cout_comb;
    end

endmodule

// 4_bit_CLA
module cla_4bit(
    input [3:0] A, B,
    input Cin,
    output [3:0] Sum,
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

    assign Sum[0] = P[0] ^ C[0];
    assign Sum[1] = P[1] ^ C[1];
    assign Sum[2] = P[2] ^ C[2];
    assign Sum[3] = P[3] ^ C[3];
   
endmodule