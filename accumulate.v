////////////////////////////////TOP MODULE//////////////////////////////////
module CSA_16BIT(   
    input [15:0] x,y,
    output [15:0] sum,
    output cout
);

wire [3:0] w_in, w_out;
wire [16:0] s;

CSA IC1(x[3:0],   y[3:0],   1'b0,    w_out[0],   s[4:0],              w_in[0]);
CSA IC2(x[7:4],   y[7:4],   w_in[0], w_out[1],  {s[8:5],w_out[0]},    w_in[1]);
CSA IC3(x[11:8],  y[11:8],  w_in[1], w_out[2],  {s[12:9],w_out[1]},   w_in[2]);
CSA_BOTTOM IC4(x[15:12], y[15:12], w_in[2], {s[16:13],w_out[2]}, cout);

// Nếu ta lấy s[16] thì kết quả sẽ sai !!! Cụ thể: khi cộng số âm và số dương sẽ ko đúng ở bit cuối
assign sum = s[15:0]; // Bỏ s[16] 
endmodule

//////////////////////////////// CSA //////////////////////////////////
module CSA       
(   input [3:0] x,y,
    input w_in,w_out,
    output [4:0] s,
    output cout
);
            
wire [3:0]c1, s1;

HA in1(x[0],y[0],s1[0],c1[0]);
HA in2(x[1],y[1],s1[1],c1[1]);
HA in3(x[2],y[2],s1[2],c1[2]);
HA in4(x[3],y[3],s1[3],c1[3]); 

RCA IC1(c1,{w_out,s1[3:1]},w_in,s[4:1],cout);

assign s[0] = s1[0];

endmodule

//////////////////////////////// CSA_BOTTOM //////////////////////////////////
module CSA_BOTTOM(
   input [3:0] x,y,
   input cin,
   output [4:0] s,
   output cout
);
            
wire [3:0]c1, s1;

HA in1(x[0],y[0],s1[0],c1[0]);
HA in2(x[1],y[1],s1[1],c1[1]);
HA in3(x[2],y[2],s1[2],c1[2]);
HA in4(x[3],y[3],s1[3],c1[3]); 

RCA_BOTTOM IC1(c1,s1[3:1],cin,s[4:1],cout);

assign s[0] = s1[0];

endmodule

///// Bottom /////
module RCA_BOTTOM(
    input [3:0]a,
    input [2:0]b,
    input cin,
    output [3:0]sum,
    output c4);

wire c1,c2,c3;      //Carry out of each full adder

FA fa1(a[0],b[0],cin,sum[0],c1);
FA fa2(a[1],b[1],c1,sum[1],c2);
FA fa3(a[2],b[2],c2,sum[2],c3);
HA ha0(a[3],c3,sum[3],c4);
endmodule

//////////////////////////////// RCA ////////////////////////////////
module RCA(
    input [3:0]a,b,
    input cin,
    output [3:0]sum,
    output c4);

wire c1,c2,c3;      //Carry out of each full adder

FA fa0(a[0],b[0],cin,sum[0],c1);
FA fa1(a[1],b[1],c1,sum[1],c2);
FA fa2(a[2],b[2],c2,sum[2],c3);
FA fa3(a[3],b[3],c3,sum[3],c4);             
endmodule

//////////////////////////////// HA //////////////////////////////////
module HA(
	input a,b,
  output sum,carry);

assign sum = a ^ b;
assign carry = a & b;

endmodule


//////////////////////////////// FA //////////////////////////////////
module FA(  
	input a,b,cin,
   output sum,carry);

assign sum = a ^ b ^ cin;
assign carry = (a & b) | (cin & b) | (a & cin);

endmodule


