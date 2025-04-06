module mux2to1 #(parameter N = 9) (
    input  [N-1:0] In0, In1,
    input  Sel,
    output [N-1:0] Out
);
    assign Out = Sel ? In1 : In0;
endmodule