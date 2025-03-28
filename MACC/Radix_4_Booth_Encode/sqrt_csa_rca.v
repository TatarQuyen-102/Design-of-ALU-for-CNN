module sqrt_csa_rsa (
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

rsa #(.N(3)) rsa_3bit_add(  .A(A[4:2]),
                            .B(B[4:2]),
                            .Cin(1'b0),
                            .Sum(o_rsa_3bit_add[2:0]),
                            .Cout(o_rsa_3bit_add[3]));

rsa #(.N(3)) rsa_3bit_sub(  .A(A[4:2]),
                            .B(B[4:2]),
                            .Cin(1'b1),
                            .Sum(o_rsa_3bit_sub[2:0]),
                            .Cout(o_rsa_3bit_sub[3]));                           

rsa #(.N(4)) rsa_4bit_add(  .A(A[8:5]),
                            .B(B[8:5]),
                            .Cin(1'b0),
                            .Sum(o_rsa_4bit_add[3:0]),
                            .Cout(o_rsa_4bit_add[4]));

rsa #(.N(4)) rsa_4bit_sub(  .A(A[8:5]),
                            .B(B[8:5]),
                            .Cin(1'b1),
                            .Sum(o_rsa_4bit_sub[3:0]),
                            .Cout(o_rsa_4bit_sub[4])); 

mux2to1 #(.N(4)) mux_4bit(  .In0(o_rsa_3bit_add), 
                            .In1(o_rsa_3bit_sub), 
                            .Sel(o_rsa_2bit[2]), 
                            .Out(o_rsa_3bit[3:0]));

mux2to1 #(.N(5)) mux_5bit(  .In0(o_rsa_4bit_add), 
                            .In1(o_rsa_4bit_sub), 
                            .Sel(o_rsa_3bit[3]), 
                            .Out(o_rsa_4bit[4:0])); 

assign Out = {o_rsa_4bit, o_rsa_3bit[2:0], o_rsa_2bit[1:0]};

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

    assign carry[0] = Cin; 
    assign B_xor = B ^ {N{Cin}};  // Nếu Cin = 1, sẽ thực hiện phép trừ A - B

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

    assign Cout = carry[N];  // Bit nhớ cuối cùng
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