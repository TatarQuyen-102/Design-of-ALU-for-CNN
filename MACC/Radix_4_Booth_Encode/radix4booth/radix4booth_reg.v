module Mul_reg (
    input clk, 
    input rst_n,
    input [7:0] x,
    input [7:0] y,
    output [14:0] o_mul
);

// output - multiply by 2
wire [8:0] m_2x;

// output - wire booth encoder
wire [2:0] o_s1_be;
wire [2:0] o_s2_be;
wire [2:0] o_s3_be;
wire [2:0] o_s4_be;

// output - wire mod bec
wire [8:0] o_s1_bec;

// output - wire mux3to1
wire [8:0] o_s1_mux3to1;
wire [8:0] o_s2_mux3to1;
wire [8:0] o_s3_mux3to1;
wire [8:0] o_s4_mux3to1;

// output - wire of each stage of multiplier
wire [8:0] o_s1;
wire [9:0] o_s2;
wire [9:0] o_s3;
wire [9:0] o_s4;

// output - D flip flop
wire [8:0] o_s1_reg;
wire [9:0] o_s2_reg;
wire [9:0] o_s3_reg;
wire [9:0] o_s4_reg;

wire [8:0] o_s1_mux3to1_not;

// multiply 2
multiplier_by_n #( .N(8), .S(1)) mul_2x(
    .A(x),
    .Y(m_2x));

// mux3to1
mux3to1 #(.N(9)) mux_s1(.A(1'b0) , .B(m_2x), .C({x[7],x}),
                        .S0(o_s1_be[0])  , .S1(o_s1_be[1]),
                        .Out(o_s1_mux3to1));

mux3to1 #(.N(9)) mux_s2(.A(1'b0) , .B(m_2x), .C({x[7],x}),
                        .S0(o_s2_be[0])  , .S1(o_s2_be[1]),
                        .Out(o_s2_mux3to1));

mux3to1 #(.N(9)) mux_s3(.A(1'b0) , .B(m_2x), .C({x[7],x}),
                        .S0(o_s3_be[0])  , .S1(o_s3_be[1]),
                        .Out(o_s3_mux3to1));

mux3to1 #(.N(9)) mux_s4(.A(1'b0) , .B(m_2x), .C({x[7],x}),
                        .S0(o_s4_be[0])  , .S1(o_s4_be[1]),
                        .Out(o_s4_mux3to1));

// booth encoder
booth_encoder be_s1( .B0(1'b0), .B1(y[0]), .B2(y[1]), 
                     .P0(o_s1_be[0]), .P1(o_s1_be[1]), .P2(o_s1_be[2]));

booth_encoder be_s2( .B0(y[1]), .B1(y[2]), .B2(y[3]), 
                     .P0(o_s2_be[0]), .P1(o_s2_be[1]), .P2(o_s2_be[2]));

booth_encoder be_s3( .B0(y[3]), .B1(y[4]), .B2(y[5]), 
                     .P0(o_s3_be[0]), .P1(o_s3_be[1]), .P2(o_s3_be[2]));

booth_encoder be_s4( .B0(y[5]), .B1(y[6]), .B2(y[7]), 
                     .P0(o_s4_be[0]), .P1(o_s4_be[1]), .P2(o_s4_be[2]));

// modified BEC of stage 1
assign o_s1_mux3to1_not = ~o_s1_mux3to1;

mod_bec mod_bec_s1(.B(o_s1_mux3to1_not),   // Đầu vào 9-bit
                   .X(o_s1_bec));

// Mux2to1 of stage 1
mux2to1 #(.N(9)) mux2to1_s1(.In0(o_s1_mux3to1), 
                            .In1(o_s1_bec), 
                            .Sel(o_s1_be[2]), 
                            .Out(o_s1_reg));

// sqrt carry save adder using RSA
sqrt_csa_bec sqrt_csa_bec_s2(.A({o_s1[8], o_s1[8], o_s1[8:2]}),
                             .B(o_s2_mux3to1), 
                             .Cin(o_s2_be[2]), 
                             .Out(o_s2_reg));

sqrt_csa_bec sqrt_csa_bec_s3(.A({o_s2[8],o_s2[8],o_s2[8:2]}), 
                             .B(o_s3_mux3to1), 
                             .Cin(o_s3_be[2]), 
                             .Out(o_s3_reg));

sqrt_csa_bec sqrt_csa_bec_s4(.A({o_s3[8],o_s3[8],o_s3[8:2]}), 
                             .B(o_s4_mux3to1), 
                             .Cin(o_s4_be[2]), 
                             .Out(o_s4_reg));

// D flip flop

dff #(.N(9)) dff_s1(.clk(clk), .rst_n(rst_n), 
                    .d(o_s1_reg), 
                    .q(o_s1));

dff #(.N(10)) dff_s2(.clk(clk), .rst_n(rst_n), 
                    .d(o_s2_reg), 
                    .q(o_s2));

dff #(.N(10)) dff_s3(.clk(clk), .rst_n(rst_n), 
                    .d(o_s3_reg), 
                    .q(o_s3));

dff #(.N(10)) dff_s4(.clk(clk), .rst_n(rst_n), 
                    .d(o_s4_reg), 
                    .q(o_s4));

assign o_mul = {o_s4, o_s3[1:0], o_s2[1:0], o_s1[1:0]};

endmodule

///////////////////////////////////////////////////////////
module booth_encoder (
    input  wire B0, B1, B2,  
    output wire P0, P1, P2  
);
      
    assign P2 = B2;  // XNOR + XOR 
    assign P1 = B0 ^ B1;               
    assign P0 = (~B2 & B1 & B0) | (B2 & ~(B1 | B0));


endmodule

///////////////////////////////////////////////////////////
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


/////////////////////////////////

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


///////////////////////////
module mux2to1 #(parameter N = 9) (
    input  [N-1:0] In0, In1,
    input  Sel,
    output [N-1:0] Out
);
    assign Out = Sel ? In1 : In0;
endmodule

///////////////////////////////////////////////////////////
module mux3to1 #(parameter N = 9) (
input  wire [N-1:0] A, B, C,  
input  wire S0, S1,         
output wire [N-1:0] Out         
);

assign Out =    (S1 == 0 && S0 == 0) ? A :
                (S1 == 0 && S0 == 1) ? B :
                (S1 == 1 && S0 == 0) ? C : A;

endmodule

///////////////////////////////////////////////////////////
// arithmetic_left_shift 
module multiplier_by_n #(parameter N = 8, parameter S = 1) (
    input  wire [N-1:0] A,
    output wire [N:0] Y
);
    assign Y = {A[N-1], A} << S;  // Dịch trái S bit
endmodule

///////////////////////////////////////////////////////////
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

    // Tính toán các giá trị đầu ra X[i]
    assign X[1] = B[1] ^ B[0];
    assign X[2] = B[2] ^ (B[1] & B[0]);
    assign X[3] = B[3] ^ AND_out[0];
    assign X[4] = B[4] ^ AND_out[1];
    assign X[5] = B[5] ^ AND_out[2];
    assign X[6] = B[6] ^ AND_out[3];
    assign X[7] = B[7] ^ AND_out[4];
    assign X[8] = B[8] ^ AND_out[5];

endmodule

//////////////////////////////////////////////////
module dff #(parameter N = 9) (clk, rst_n, d, q);
input clk;
input rst_n;
input [N-1:0] d;
output reg [N-1:0] q;

//Flip Flop with asynchronous reset: 
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) 
        q <= 0; 
    else 
        q <= d; 
end
endmodule

/////////////////////////////////////////////////////////////////////////////////////////////