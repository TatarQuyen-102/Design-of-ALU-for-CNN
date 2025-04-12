module Mul (
    input clk,        // Thêm tín hiệu clock để đồng bộ thanh ghi
    input rst_n,      // Thêm tín hiệu reset
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

wire [8:0] o_s1_mux3to1_not;

// Các thanh ghi cho pipeline
reg [8:0] reg_m_2x;
reg [2:0] reg_s1_be, reg_s2_be, reg_s3_be, reg_s4_be;
reg [8:0] reg_s1_mux3to1, reg_s2_mux3to1, reg_s3_mux3to1, reg_s4_mux3to1;
reg [8:0] reg_s1;
reg [9:0] reg_s2, reg_s3, reg_s4;
reg [7:0] reg_x;
reg [7:0] reg_y;
reg [14:0] reg_o_mul;

// Thanh ghi đầu vào
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_x <= 8'b0;
        reg_y <= 8'b0;
    end else begin
        reg_x <= x;
        reg_y <= y;
    end
end

// multiply 2
multiplier_by_n #(.N(8), .S(1)) mul_2x(
    .A(reg_x),
    .Y(m_2x));

// Thanh ghi bậc 1
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_m_2x <= 9'b0;
    end else begin
        reg_m_2x <= m_2x;
    end
end

// booth encoder
booth_encoder be_s1(.B0(1'b0), .B1(reg_y[0]), .B2(reg_y[1]), 
                    .P0(o_s1_be[0]), .P1(o_s1_be[1]), .P2(o_s1_be[2]));

booth_encoder be_s2(.B0(reg_y[1]), .B1(reg_y[2]), .B2(reg_y[3]), 
                    .P0(o_s2_be[0]), .P1(o_s2_be[1]), .P2(o_s2_be[2]));

booth_encoder be_s3(.B0(reg_y[3]), .B1(reg_y[4]), .B2(reg_y[5]), 
                    .P0(o_s3_be[0]), .P1(o_s3_be[1]), .P2(o_s3_be[2]));

booth_encoder be_s4(.B0(reg_y[5]), .B1(reg_y[6]), .B2(reg_y[7]), 
                    .P0(o_s4_be[0]), .P1(o_s4_be[1]), .P2(o_s4_be[2]));

// Thanh ghi bậc 2
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s1_be <= 3'b0;
        reg_s2_be <= 3'b0;
        reg_s3_be <= 3'b0;
        reg_s4_be <= 3'b0;
    end else begin
        reg_s1_be <= o_s1_be;
        reg_s2_be <= o_s2_be;
        reg_s3_be <= o_s3_be;
        reg_s4_be <= o_s4_be;
    end
end

// mux3to1
mux3to1 #(.N(9)) mux_s1(.A(1'b0), .B(reg_m_2x), .C({reg_x[7],reg_x}),
                         .S0(reg_s1_be[0]), .S1(reg_s1_be[1]),
                         .Out(o_s1_mux3to1));

mux3to1 #(.N(9)) mux_s2(.A(1'b0), .B(reg_m_2x), .C({reg_x[7],reg_x}),
                         .S0(reg_s2_be[0]), .S1(reg_s2_be[1]),
                         .Out(o_s2_mux3to1));

mux3to1 #(.N(9)) mux_s3(.A(1'b0), .B(reg_m_2x), .C({reg_x[7],reg_x}),
                         .S0(reg_s3_be[0]), .S1(reg_s3_be[1]),
                         .Out(o_s3_mux3to1));

mux3to1 #(.N(9)) mux_s4(.A(1'b0), .B(reg_m_2x), .C({reg_x[7],reg_x}),
                         .S0(reg_s4_be[0]), .S1(reg_s4_be[1]),
                         .Out(o_s4_mux3to1));

// Thanh ghi bậc 3
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s1_mux3to1 <= 9'b0;
        reg_s2_mux3to1 <= 9'b0;
        reg_s3_mux3to1 <= 9'b0;
        reg_s4_mux3to1 <= 9'b0;
    end else begin
        reg_s1_mux3to1 <= o_s1_mux3to1;
        reg_s2_mux3to1 <= o_s2_mux3to1;
        reg_s3_mux3to1 <= o_s3_mux3to1;
        reg_s4_mux3to1 <= o_s4_mux3to1;
    end
end

// modified BEC of stage 1
assign o_s1_mux3to1_not = ~reg_s1_mux3to1;

mod_bec mod_bec_s1(.B(o_s1_mux3to1_not),
                   .X(o_s1_bec));

// Mux2to1 of stage 1
mux2to1 #(.N(9)) mux2to1_s1(.In0(reg_s1_mux3to1), 
                            .In1(o_s1_bec), 
                            .Sel(reg_s1_be[2]), 
                            .Out(o_s1));

// Thanh ghi bậc 4
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s1 <= 9'b0;
    end else begin
        reg_s1 <= o_s1;
    end
end

// sqrt carry save adder using RSA
sqrt_csa_bec sqrt_csa_bec_s2(.A({reg_s1[8], reg_s1[8], reg_s1[8:2]}),
                             .B(reg_s2_mux3to1), 
                             .Cin(reg_s2_be[2]), 
                             .Out(o_s2));

// Thanh ghi bậc 5
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s2 <= 10'b0;
    end else begin
        reg_s2 <= o_s2;
    end
end

sqrt_csa_bec sqrt_csa_bec_s3(.A({reg_s2[8], reg_s2[8], reg_s2[8:2]}), 
                             .B(reg_s3_mux3to1), 
                             .Cin(reg_s3_be[2]), 
                             .Out(o_s3));

// Thanh ghi bậc 6
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s3 <= 10'b0;
    end else begin
        reg_s3 <= o_s3;
    end
end

sqrt_csa_bec sqrt_csa_bec_s4(.A({reg_s3[8], reg_s3[8], reg_s3[8:2]}), 
                             .B(reg_s4_mux3to1), 
                             .Cin(reg_s4_be[2]), 
                             .Out(o_s4));

// Thanh ghi bậc 7
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_s4 <= 10'b0;
    end else begin
        reg_s4 <= o_s4;
    end
end

// Kết nối các bit đầu ra
wire [14:0] mul_result;
assign mul_result = {reg_s4, reg_s3[1:0], reg_s2[1:0], reg_s1[1:0]};

// Thanh ghi đầu ra cuối cùng
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        reg_o_mul <= 15'b0;
    end else begin
        reg_o_mul <= mul_result;
    end
end

assign o_mul = reg_o_mul;

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
