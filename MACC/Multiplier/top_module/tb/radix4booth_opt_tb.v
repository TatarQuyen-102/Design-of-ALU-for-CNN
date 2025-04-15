`timescale 1ns / 1ps

module Mul_tb;
    // Inputs
    reg clk;
    reg rst_n;
    reg signed [7:0] x;
    reg signed [7:0] y;
    
    // Output
    wire signed [14:0] o_mul;
    
    // Expected results for verification
    reg signed [15:0] expected_results;
    
    // Instantiate the Unit Under Test (UUT)
    Mul uut (
        .clk(clk),
        .rst_n(rst_n),
        .x(x),
        .y(y),
        .o_mul(o_mul)
    );
    
    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 100MHz clock
    end
    
    // Test sequence counter
    integer test_count = 0;
    integer i;
    integer error_count = 0;
    
    // Test cases
    reg [7:0] test_x [0:29];
    reg [7:0] test_y [0:29];
    
    initial begin
        // Initialize test cases
        test_x[0] = 8'b00000001; test_y[0] = 8'b00000001; // 1 * 1
        test_x[1] = 8'b00000010; test_y[1] = 8'b00000010; // 2 * 2
        test_x[2] = 8'b00001000; test_y[2] = 8'b00000011; // 8 * 3
        test_x[3] = 8'b00001111; test_y[3] = 8'b00001111; // 15 * 15
        test_x[4] = 8'b00111000; test_y[4] = 8'b00011001; // 56 * 25
        test_x[5] = 8'b00000000; test_y[5] = 8'b00000000; // 0 * 0
        test_x[6] = 8'b00000001; test_y[6] = 8'b00000000; // 1 * 0
        test_x[7] = 8'b00000000; test_y[7] = 8'b00000001; // 0 * 1
        test_x[8] = 8'b01111111; test_y[8] = 8'b01111111; // 127 * 127
        test_x[9] = 8'b11111111; test_y[9] = 8'b11111111; // -1 * -1
        test_x[10] = 8'b11111111; test_y[10] = 8'b00000001; // -1 * 1
        test_x[11] = 8'b10000000; test_y[11] = 8'b00000001; // -128 * 1
        test_x[12] = 8'b10000000; test_y[12] = 8'b10000000; // -128 * -128
        test_x[13] = 8'b10101010; test_y[13] = 8'b01010101; // -86 * 85
        test_x[14] = 8'b00000100; test_y[14] = 8'b00000011; // 4 * 3
        test_x[15] = 8'b00001011; test_y[15] = 8'b00000110; // 11 * 6
        test_x[16] = 8'b00000001; test_y[16] = 8'b11111111; // 1 * -1
        test_x[17] = 8'b01010101; test_y[17] = 8'b10101010; // 85 * -86
        test_x[18] = 8'b01100100; test_y[18] = 8'b00001010; // 100 * 10
        test_x[19] = 8'b00101010; test_y[19] = 8'b00001010; // 42 * 10
        test_x[20] = 8'b11110000; test_y[20] = 8'b00001111; // -16 * 15
        test_x[21] = 8'b00010110; test_y[21] = 8'b11111100; // 22 * -4
        test_x[22] = 8'b10000001; test_y[22] = 8'b00000010; // -127 * 2
        test_x[23] = 8'b00000011; test_y[23] = 8'b00000011; // 3 * 3
        test_x[24] = 8'b11111110; test_y[24] = 8'b11111101; // -2 * -3
        test_x[25] = 8'b00110011; test_y[25] = 8'b01010101; // 51 * 85
        test_x[26] = 8'b11001100; test_y[26] = 8'b00110011; // -52 * 51
        test_x[27] = 8'b01111111; test_y[27] = 8'b00000001; // 127 * 1
        test_x[28] = 8'b11100001; test_y[28] = 8'b00000100; // -31 * 4
        test_x[29] = 8'b00010010; test_y[29] = 8'b11101111; // 18 * -17

    end
    
    // Setup waveform dump
    initial begin
        $dumpfile("mul_opt_tb.vcd");
        $dumpvars(0, Mul_tb);
        
        // Header for the test report
        $display("========================================================================");
        $display("                     PIPELINE MULTIPLIER TESTBENCH                      ");
        $display("========================================================================");
        $display("Time  |    X    |    Y    |     Output     |    Expected    |  Status  ");
        $display("----------------------------------------------------------------------");
    end
    
    // Reset and test sequence
    initial begin
        // Initial reset
        rst_n = 0;
        x = 0;
        y = 0;
        #20;
        rst_n = 1;
        #10;
        
        // Apply all test cases
        for (i = 0; i < 30; i = i + 1) begin
            @(posedge clk);
            x = test_x[i];
            y = test_y[i];
            
            // Calculate expected result in simulation
            expected_results = $signed(x) * $signed(y);
            
            // Wait for pipeline stages (8 clock cycles for 8-stage pipeline)
            #80;
            
            // Check result
            if ($signed(o_mul) !== expected_results[14:0]) begin
                $display("%4t  | %4d (%b) | %4d (%b) | %6d (%b) | %6d (%b) | ERROR", 
                         $time, $signed(x), x, $signed(y), y, 
                         $signed(o_mul), o_mul, 
                         expected_results[14:0], expected_results[14:0]);
                error_count = error_count + 1;
            end else begin
                $display("%4t  | %4d (%b) | %4d (%b) | %6d (%b) | %6d (%b) | PASS", 
                         $time, $signed(x), x, $signed(y), y, 
                         $signed(o_mul), o_mul, 
                         expected_results[14:0], expected_results[14:0]);
            end
            
            test_count = test_count + 1;
        end
        
        // Summary
        $display("========================================================================");
        if (error_count == 0) begin
            $display("TEST SUMMARY: All %0d tests PASSED", test_count);
        end else begin
            $display("TEST SUMMARY: %0d out of %0d tests FAILED", error_count, test_count);
        end
        $display("========================================================================");
        
        $display("Pipeline Delay Analysis:");
        $display("* Total pipeline stages: 8 (including input and output registers)");
        $display("* Latency: 8 clock cycles (40ns at 100MHz)");
        $display("* Throughput: 1 result per clock cycle after initial latency");
        $display("========================================================================");
        
        $finish;
    end
    
    // Monitor internal pipeline stages (optional - uncomment for detailed debugging)
    /*
    initial begin
        $display("Internal Pipeline Stage Monitoring:");
        $display("Time  | Stage | Values");
        $monitor("%4t   | Input | x=%b, y=%b\n\
                 | Reg1  | reg_m_2x=%b\n\
                 | Reg2  | reg_s1_be=%b, reg_s2_be=%b, reg_s3_be=%b, reg_s4_be=%b\n\
                 | Reg3  | reg_s1_mux3to1=%b\n\
                 | Reg4  | reg_s1=%b\n\
                 | Reg5  | reg_s2=%b\n\
                 | Reg6  | reg_s3=%b\n\
                 | Reg7  | reg_s4=%b\n\
                 | Out   | o_mul=%b", 
                $time, 
                x, y,
                uut.reg_m_2x,
                uut.reg_s1_be, uut.reg_s2_be, uut.reg_s3_be, uut.reg_s4_be,
                uut.reg_s1_mux3to1,
                uut.reg_s1,
                uut.reg_s2,
                uut.reg_s3,
                uut.reg_s4,
                o_mul);
    end
    */
endmodule