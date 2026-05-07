module main_decoder(
    input        zero,
    input  [6:0] op,

    output       RegWrite,
    output       MemWrite,
    output       ResultSrc,
    output       ALUSrc,
    output       PCSrc,
    output [1:0] ImmSrc,
    output [1:0] ALUOp
);

    wire branch;

    // 7'b0110011 -> R-type
    // 7'b0000011 -> LOAD
    // 7'b0100011 -> STORE
    // 7'b1100011 -> BRANCH

    // Register write enable
    assign RegWrite =
        ((op == 7'b0000011) || (op == 7'b0110011)) ? 1'b1 : 1'b0;

    // Memory write enable
    assign MemWrite =
        (op == 7'b0100011) ? 1'b1 : 1'b0;

    // Result source (1 = memory, 0 = ALU)
    assign ResultSrc =
        (op == 7'b0000011) ? 1'b1 : 1'b0;

    // ALU source (1 = immediate, 0 = register)
    assign ALUSrc =
        ((op == 7'b0000011) || (op == 7'b0100011)) ? 1'b1 : 1'b0;

    // Branch instruction detect
    assign branch =
        (op == 7'b1100011) ? 1'b1 : 1'b0;

    // Immediate source select
    // 00 = I-type
    // 01 = S-type
    // 10 = B-type
    assign ImmSrc =
        (op == 7'b0100011) ? 2'b01 :
        (op == 7'b1100011) ? 2'b10 :
        2'b00;

    // ALU operation select
    // 00 = add (load/store)
    // 01 = subtract/branch compare
    // 10 = R-type decode
    assign ALUOp =
        (op == 7'b0110011) ? 2'b10 :
        (op == 7'b1100011) ? 2'b01 :
        2'b00;

    // PC source control
    assign PCSrc = zero & branch;

endmodule