module ALU (
    input  [31:0] A, //Operand 1(32 bit), from rs1
    input  [31:0] B, //Operand 2(32 bit), from rs2 or immediate
    input  [2:0]  ALUControl, //3 bit control from ALU_Decoder

    output [31:0] Result, //32 bit math/logic out
    output        OverFlow, //High if signed math overflows
    output        Carry, //High if unsigned math carries over
    output        Zero, //High if result = 0
    output        Negative //High if result is negative
);

    wire [31:0] Sum; //Internal wire for add/sub result
    wire        Cout; //Internal wire for adder carry out

    // ADD or SUB
    assign {Cout, Sum} =
        (ALUControl == 3'b001) ?
        (A + (~B + 1'b1)) :   // SUB: add A to negative of B, two's comp.
        (A + B);              // ADD: else, add

    // ALU operations
    assign Result =
        (ALUControl == 3'b000) ? Sum :                    // ADD
        (ALUControl == 3'b001) ? Sum :                    // SUB
        (ALUControl == 3'b010) ? (A & B) :               // Bitwise AND
        (ALUControl == 3'b011) ? (A | B) :               // Bitwise OR
        (ALUControl == 3'b101) ? {{31{1'b0}}, Sum[31]} :// SLT
                                 32'b0;                 // default to 0

    // Overflow detection, for ADD/SUB, checks if out of bounds(pos + pos = neg)
    assign OverFlow =
        (~ALUControl[1]) & //If add/sub instruction...
        (A[31] ^ Sum[31]) & //... and input A differs from sum's sign...
        ~(A[31] ^ B[31] ^ ALUControl[0]);//...and A and B signs are the same

    // Carry flag
    assign Carry = (~ALUControl[1]) & Cout; //33rd bit is 1

    // Zero flag
    assign Zero = (Result == 32'b0); //If result is all 0's, for BEQ

    // Negative flag
    assign Negative = Result[31]; //If last bit is 1, it is negative

endmodule