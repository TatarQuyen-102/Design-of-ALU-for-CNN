
module POOLING #(parameter BIT_WIDTH=8)
(
    // 16x16 pooling window
    input reset,          // system reset
    input clk,            // system clock
    input [8:0] inX_sel,  // select the input or 0
    input [BIT_WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8,
    output [BIT_WIDTH-1:0] out
);

    // Intermediate wires for selected inputs
    wire [BIT_WIDTH-1:0] in0_sel, in1_sel, in2_sel, in3_sel, in4_sel, in5_sel, in6_sel, in7_sel, in8_sel;

    // Intermediate wires for max pooling
    wire [BIT_WIDTH-1:0] max0, max1, max2, max3, max4, max5, max6, out_max;

    // Decide if the input is included in max pooling
    assign in0_sel = inX_sel[0] ? in0 : 'h0;
    assign in1_sel = inX_sel[1] ? in1 : 'h0;
    assign in2_sel = inX_sel[2] ? in2 : 'h0;
    assign in3_sel = inX_sel[3] ? in3 : 'h0;
    assign in4_sel = inX_sel[4] ? in4 : 'h0;
    assign in5_sel = inX_sel[5] ? in5 : 'h0;
    assign in6_sel = inX_sel[6] ? in6 : 'h0;
    assign in7_sel = inX_sel[7] ? in7 : 'h0;
    assign in8_sel = inX_sel[8] ? in8 : 'h0;

    // Max pooling logic
 GREATER STEP1( .A(in0_sel), .B(in1_sel), .MUX_Out(max0));   
 GREATER STEP2( .A(max0), .B(in2_sel), .MUX_Out(max1));   
 GREATER STEP3( .A(max1), .B(in3_sel), .MUX_Out(max2));  
 GREATER STEP4( .A(max2), .B(in4_sel), .MUX_Out(max3));   
 GREATER STEP5( .A(max3), .B(in5_sel), .MUX_Out(max4));   
 GREATER STEP6( .A(max4), .B(in6_sel), .MUX_Out(max5));
 GREATER STEP7( .A(max5), .B(in7_sel), .MUX_Out(max6));   
 GREATER STEP_OUT( .A(max6), .B(in8_sel), .MUX_Out(out_max));   
  
 assign out = out_max;

endmodule // POOLING
	

/////// SN74LS85 and MUX //////
// Compare A and B and then get max value
module GREATER (
    input [7:0] A,         // 8-bit input A
    input [7:0] B,         // 8-bit input B
    output [7:0] MUX_Out   // Output of the 8-bit MUX
);

    // Wire signals for cascading
	  wire lower_A_Less_B, lower_A_Equal_B, lower_A_Greater_B;
    wire upper_A_Less_B, upper_A_Equal_B, upper_A_Greater_B;

    // Wires for NOTed A[7] and B[7]
    wire not_A7, not_B7;

    // Invert A[7] and B[7]
    assign not_A7 = ~A[7];
    assign not_B7 = ~B[7];

    // Instantiate 4-bit comparator for lower 4 bits
    SN74LS85 lower_4bit (
        .A(A[3:0]),
        .B(B[3:0]),
        .A_gt_B_in(1'b1),
        .A_eq_B_in(1'b1),
        .A_lt_B_in(1'b1),
        .A_gt_B(lower_A_Greater_B),
        .A_eq_B(lower_A_Equal_B),
        .A_lt_B(lower_A_Less_B)
    );

    // Instantiate 4-bit comparator for upper 4 bits with NOTed A[7] and B[7]
    SN74LS85 upper_4bit (
        .A({not_A7, A[6:4]}),    // Replace A[7] with NOTed A[7]
        .B({not_B7, B[6:4]}),    // Replace B[7] with NOTed B[7]
        .A_gt_B_in(lower_A_Greater_B),
        .A_eq_B_in(lower_A_Equal_B),
        .A_lt_B_in(lower_A_Less_B),
        .A_gt_B(upper_A_Greater_B),
        .A_eq_B(upper_A_Equal_B),
        .A_lt_B(upper_A_Less_B)
    );

    // Assign final comparator outputs
    assign O_A_Less_B    = upper_A_Less_B;
    assign O_A_Equal_B   = upper_A_Equal_B;
    assign O_A_Greater_B = upper_A_Greater_B;

    // Instantiate 8-bit 2-to-1 MUX
    MUX_2to1_8bit mux_8bit (
        .in0(B),              // Input 0 is A
        .in1(A),              // Input 1 is B
        .sel(O_A_Greater_B),  // Select signal from comparator
        .out(MUX_Out)         // Output of the MUX
    );

endmodule

///////// MUX 2to1 ////////
module MUX_2to1_8bit (
    input [7:0] in0,   // Input 0
    input [7:0] in1,   // Input 1
    input sel,         // Select signal
    output [7:0] out   // Output
);

    // MUX logic for each bit
    assign out = sel ? in1 : in0;

endmodule

/////// SN74LS85 (4 bit) //////
module SN74LS85 (
input  wire [3:0] A,          // 4-bit input A
input  wire [3:0] B,          // 4-bit input B
input  wire A_gt_B_in,        // Cascading input A > B
input  wire A_eq_B_in,        // Cascading input A = B
input  wire A_lt_B_in,        // Cascading input A < B
output wire A_gt_B,           // Output A > B
output wire A_eq_B,           // Output A = B
output wire A_lt_B            // Output A < B
);

// Intermediate comparison signals
wire [3:0] y;    // NAND of corresponding A and B bits
wire [3:0] x;    // Intermediate comparison results

// Generate NAND terms for each bit position
assign y[3] = ~(A[3] & B[3]);
assign y[2] = ~(A[2] & B[2]);
assign y[1] = ~(A[1] & B[1]);
assign y[0] = ~(A[0] & B[0]);

// Generate intermediate comparison terms
assign x[3] = ~((A[3] & y[3]) | (B[3] & y[3]));  // For bit 3 (MSB)
assign x[2] = ~((A[2] & y[2]) | (B[2] & y[2]));  // For bit 2
assign x[1] = ~((A[1] & y[1]) | (B[1] & y[1]));  // For bit 1
assign x[0] = ~((A[0] & y[0]) | (B[0] & y[0]));  // For bit 0 (LSB)

// Wire for equality condition
wire all_equal;
assign all_equal = x[3] & x[2] & x[0];

// A > B output logic
assign A_gt_B = ~(
(B[3] & y[3]) |                           // B[3] > A[3]
(B[2] & y[2] & x[3]) |                    // Equal in bit 3, B[2] > A[2]
(B[1] & y[1] & x[3] & x[2]) |            // Equal in bits 3-2, B[1] > A[1]
(B[0] & y[0] & x[3] & x[2] & x[1]) |     // Equal in bits 3-1, B[0] > A[0]
(all_equal & A_lt_B_in) |
(all_equal & A_eq_B_in) // All bits equal, use cascade inputs
);

// A = B output logic
assign A_eq_B = all_equal & A_eq_B_in;

// A < B output logic
assign A_lt_B = ~(
(A[3] & y[3]) |                           // A[3] > B[3]
(A[2] & y[2] & x[3]) |                    // Equal in bit 3, A[2] > B[2]
(A[1] & y[1] & x[3] & x[2]) |            // Equal in bits 3-2, A[1] > B[1]
(A[0] & y[0] & x[3] & x[2]) |     // Equal in bits 3-1, A[0] > B[0]
(all_equal & x[1]) |
(all_equal & A_gt_B_in)    // All bits equal, use cascade inputs
);

endmodule
