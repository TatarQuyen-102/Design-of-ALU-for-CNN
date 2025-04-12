`timescale 1ns / 1ps

module relu_out_tb;

    // Inputs
    reg cmp_flag;
    reg [7:0] cmp_val;
    reg [15:0] val_in;

    // Output
    wire [7:0] val_out;

    // Instantiate the DUT
    ReLU_out uut (
        .cmp_flag(cmp_flag),
        .cmp_val(cmp_val),
        .val_in(val_in),
        .val_out(val_out)
    );

    // Dump waveform for GTKWave (optional)
    initial begin
        $dumpfile("relu_out_tb.vcd");
        $dumpvars(0, relu_out_tb);
    end

    // Monitor output
    initial begin
        $display("Time | cmp_flag | val_in      | cmp_val | val_out");
        $monitor("%4t |    %b     |  %d  |   %3d    |   %d", 
                 $time, cmp_flag, val_in, cmp_val, val_out);
    end

    // Test vectors
    initial begin
        cmp_flag = 0; cmp_val = 8'd100; val_in = 16'd50;   #10;
        cmp_flag = 0; cmp_val = 8'd100; val_in = 16'd150;  #10;
        cmp_flag = 0; cmp_val = 8'd100; val_in = -16'sd20; #10;

        cmp_flag = 1; cmp_val = 8'd100; val_in = 16'd50;   #10;
        cmp_flag = 1; cmp_val = 8'd100; val_in = 16'd150;  #10;
        cmp_flag = 1; cmp_val = 8'd50;  val_in = 16'd70;   #10;
        cmp_flag = 1; cmp_val = 8'd200; val_in = -16'sd10; #10;

        #10;
        $finish;
    end

endmodule
