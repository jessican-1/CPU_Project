module ALU (
    input  [31:0] A,
    input  [31:0] B,
    input  [2:0]  ALUControl,

    output [31:0] Result,
    output        OverFlow,
    output        Carry,
    output        Zero,
    output        Negative
);

    wire [31:0] Sum;
    wire        Cout;

    // ADD or SUB
    assign {Cout, Sum} =
        (ALUControl == 3'b001) ?
        (A + (~B + 1'b1)) :   // SUB
        (A + B);              // ADD

    // ALU operations
    assign Result =
        (ALUControl == 3'b000) ? Sum :                    // ADD
        (ALUControl == 3'b001) ? Sum :                    // SUB
        (ALUControl == 3'b010) ? (A & B) :               // AND
        (ALUControl == 3'b011) ? (A | B) :               // OR
        (ALUControl == 3'b101) ? {{31{1'b0}}, Sum[31]} :// SLT
                                 32'b0;

    // Overflow detection
    assign OverFlow =
        (~ALUControl[1]) &
        (A[31] ^ Sum[31]) &
        ~(A[31] ^ B[31] ^ ALUControl[0]);

    // Carry flag
    assign Carry = (~ALUControl[1]) & Cout;

    // Zero flag
    assign Zero = (Result == 32'b0);

    // Negative flag
    assign Negative = Result[31];

endmodule