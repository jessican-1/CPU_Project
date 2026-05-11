module PC_Adder (

    input [31:0]a, //current PC
    input [31:0]b, //4 or branch offset
    output [31:0]c //next address
);
    assign c = a + b;
    
endmodule