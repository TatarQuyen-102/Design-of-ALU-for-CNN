module ReLU_out(
    input wire cmp_flag,
    input wire [7:0] cmp_val,
    input wire [15:0] val_in,
    output reg [7:0] val_out
);

    wire [7:0] temp_relu, temp_clip;

    // Instantiate submodules
    ReLU ReLU_inst(
        .val_in(val_in),
        .temp_relu(temp_relu)
    );

    LESS Comparator1(
        .A(temp_relu),
        .B(cmp_val),
        .MUX_Out(temp_clip)
    );

    // Control logic for output
    always @(*) begin
        if (cmp_flag) 
            val_out <= temp_clip;
        else 
            val_out <= temp_relu;
    end

endmodule

// ReLU Module - negative number to become zero
module ReLU #(parameter IP_WIDTH = 16, OP_WIDTH = 8) (
    input [IP_WIDTH-1:0] val_in,
    output [OP_WIDTH-1:0] temp_relu
);
    assign temp_relu = val_in[IP_WIDTH-1] ? 0 : val_in;
endmodule

// LESS module
module LESS (
    input [7:0] A,         // 8-bit input A
    input [7:0] B,         // 8-bit input B
    output [7:0] MUX_Out   // Output of the 8-bit MUX
);

    // Wire signals for cascading
	  wire lower_A_Less_B, lower_A_Equal_B, lower_A_Greater_B;
    wire upper_A_Less_B, upper_A_Equal_B, upper_A_Greater_B;

    // Wires for NOT A[7] and B[7] to compare signed and get signed
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
        .in0(A),              // Input 0 is A
        .in1(B),              // Input 1 is B
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