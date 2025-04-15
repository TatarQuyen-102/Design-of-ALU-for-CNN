`timescale 1ns / 1ps

module tb_mux2to1;
// Declare testbench signals
reg [8:0] In0, In1;
reg Sel;
wire [8:0] Out;

// Instantiate the mux2to1 module
mux2to1 #(.N(9)) dut (In0, In1, Sel, Out);

// Apply test stimulus
initial begin
    $dumpfile("mux2to1_tb.vcd"); // Tạo file VCD để xem bằng GTKWave
    $dumpvars(0, tb_mux2to1);

    $display("Testing 2-to-1 Multiplexer");
    $monitor("Time=%0t | Sel=%b | In0=%b | In1=%b | Out=%b", $time, Sel, In0, In1, Out);

    // Apply various test cases
    In0 = 9'b000000001; In1 = 9'b111111111; Sel = 0; #10; // Expect Out = In0
    In0 = 9'b000000001; In1 = 9'b111111111; Sel = 1; #10; // Expect Out = In1
    In0 = 9'b101010101; In1 = 9'b010101010; Sel = 0; #10; // Expect Out = In0
    In0 = 9'b101010101; In1 = 9'b010101010; Sel = 1; #10; // Expect Out = In1
    In0 = 9'b000000000; In1 = 9'b111111111; Sel = 0; #10; // Expect Out = In0
    In0 = 9'b000000000; In1 = 9'b111111111; Sel = 1; #10; // Expect Out = In1

    $display("TEST COMPLETED");
    $finish;
end

endmodule
