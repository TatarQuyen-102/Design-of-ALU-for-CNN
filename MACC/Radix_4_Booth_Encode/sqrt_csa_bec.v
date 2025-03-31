module sqrt_csa_bec (
    A,
    B,
    Cin,
    Out
);

input [8:0] A;
input [8:0] B;
input Cin;
output [9:0] Out;

wire [2:0] o_rsa_2bit;

wire [3:0] o_rsa_3bit;
wire [3:0] o_rsa_3bit_add;
wire [3:0] o_rsa_3bit_sub;

wire [4:0] o_rsa_4bit;
wire [4:0] o_rsa_4bit_add;
wire [4:0] o_rsa_4bit_sub;

rsa #(.N(2)) rsa_2bit(  .A(A[1:0]),
                        .B(B[1:0]),
                        .Cin(Cin),
                        .Sum(o_rsa_2bit[1:0]),
                        .Cout(o_rsa_2bit[2]));

rsa #(.N(3)) rsa_3bit(  .A(A[4:2]),
                        .B(B[4:2]),
                        .Cin(Cin),
                        .Sum(o_rsa_3bit_add[2:0]),
                        .Cout(o_rsa_3bit_add[3]));

rsa #(.N(4)) rsa_4bit(  .A(A[8:5]),
                        .B(B[8:5]),
                        .Cin(Cin),
                        .Sum(o_rsa_4bit_add[3:0]),
                        .Cout(o_rsa_4bit_add[4]));

// Binary two’s complement block

b2c_4bit bec_rsa_3bit(  .B(o_rsa_3bit_add),
                        .X(o_rsa_3bit_sub));

b2c_5bit bec_rsa_4bit(  .B(o_rsa_4bit_add),
                        .X(o_rsa_4bit_sub));  

mux2to1 #(.N(4)) mux_rsa_3bit(  .In0(o_rsa_3bit_add), 
                                .In1(o_rsa_3bit_sub), 
                                .Sel(o_rsa_2bit[2]), 
                                .Out(o_rsa_3bit));

mux2to1 #(.N(5)) mux_rsa_4bit(  .In0(o_rsa_4bit_add), 
                                .In1(o_rsa_4bit_sub), 
                                .Sel(o_rsa_3bit[3]), 
                                .Out(o_rsa_4bit));

assign Out = {o_rsa_4bit, o_rsa_3bit[2:0], o_rsa_2bit[1:0]};

endmodule                   


///////////////////////////////////////////////////////
module mux2to1 #(parameter N = 9) (
    input  [N-1:0] In0, In1,
    input  Sel,
    output [N-1:0] Out
);
    assign Out = Sel ? In1 : In0;
endmodule

///////////////////////////////////////////////////////
module b2c_4bit (
    input [3:0] B,  
    output [3:0] X   
);

    assign X[0] = ~B[0];
    assign X[1] = B[1] ^ B[0];
    assign X[2] = B[2] ^ (B[1] & B[0]);
    assign X[3] = B[3] ^ (B[0] & B[1] & B[2]);

endmodule

///////////////////////////////////////////////////////
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

///////////////////////////////////////////////////////
module rsa #( parameter N = 4 ) (
    input  wire [N-1:0] A, B,  // Các toán hạng đầu vào
    input  wire Cin,           // Bit nhớ vào
    output wire [N-1:0] Sum,   // Tổng đầu ra
    output wire Cout           // Bit nhớ ra
);
    wire [N:0] carry;          // Dây để truyền bit nhớ giữa các bộ cộng
    wire [N-1:0] B_xor;        // B XOR với Cin để hỗ trợ phép trừ khi cần

    assign B_xor = B ^ {N{Cin}};  // Nếu Cin = 1, sẽ thực hiện phép trừ A - B
    assign carry[0] = Cin; 
    

    genvar i;
    generate
        for (i = 0; i < N; i = i + 1) begin : adder_stage
            full_adder FA (
                .A(A[i]), 
                .B(B_xor[i]), 
                .Cin(carry[i]), 
                .Sum(Sum[i]), 
                .Cout(carry[i+1])
            );
        end
    endgenerate

    assign carry_sign = carry[N];  
    assign Cout = carry_sign ^ Cin;  // Xữ lý bit có dấu khi trừ

endmodule


// Full Adder 1-bit
module full_adder (
    input  wire A, B, Cin,  
    output wire Sum, Cout   
);
    assign Sum  = A ^ B ^ Cin; 
    assign Cout = (A & B) | (A & Cin) | (B & Cin);  
endmodule
