module booth_encoder (
    input  wire B0, B1, B2,  
    output wire P0, P1, P2  
);
      
    assign P2 = B2;  // XNOR + XOR 
    assign P1 = B0 ^ B1;               
    assign P0 = (~B2 & B1 & B0) | (B2 & ~(B1 | B0));


endmodule