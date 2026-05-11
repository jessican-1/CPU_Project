module Mux (

    input [31:0]a,//a
    input [31:0]b,//b
    input s, //selector signal
    output [31:0]c//output
);
    assign c = (~s) ? a : b ; //s = 0 -> c = a, s = 1 -> c = b
    
endmodule