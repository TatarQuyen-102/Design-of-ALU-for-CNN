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

// //Flip Flop with synchronous reset: 
// always @(posedge clk) 
// if (~rst_n) 
// q <= 0; 
// else 
// q <= d;

endmodule