`timescale 1ns / 1ps

module pooling_tb;

    // Parameters
    parameter BIT_WIDTH = 8;

    // Inputs
    reg reset;
    reg clk;
    reg [8:0] inX_sel;
    reg [BIT_WIDTH-1:0] in0, in1, in2, in3, in4, in5, in6, in7, in8;

    // Output
    wire [BIT_WIDTH-1:0] out;

    // Instantiate the DUT
    POOLING #(BIT_WIDTH) uut (
        .reset(reset),
        .clk(clk),
        .inX_sel(inX_sel),
        .in0(in0), .in1(in1), .in2(in2),
        .in3(in3), .in4(in4), .in5(in5),
        .in6(in6), .in7(in7), .in8(in8),
        .out(out)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $display("Time\tinX_sel\t\t\t\tout");
        $monitor("%0dns\t%b\t\t%d", $time, inX_sel, out);

        // Initialize inputs
        clk = 0;
        reset = 0;

        in0 = 8'd10;
        in1 = 8'd20;
        in2 = 8'd30;
        in3 = 8'd40;
        in4 = 8'd50;
        in5 = 8'd60;
        in6 = 8'd70;
        in7 = 8'd80;
        in8 = 8'd90;

        // Test 1: select all inputs
        inX_sel = 9'b111111111; // max = 90
        #10;

        // Test 2: select only first 3 inputs
        inX_sel = 9'b000000111; // max = 30
        #10;

        // Test 3: select middle inputs
        inX_sel = 9'b000111000; // max = 60
        #10;

        // Test 4: select only one input
        inX_sel = 9'b000000100; // only in2 selected, out = 30
        #10;

        // Test 5: no input selected
        inX_sel = 9'b000000000; // out = 0
        #10;

        $finish;
    end

endmodule
