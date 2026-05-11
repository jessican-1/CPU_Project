`include "ALU_Decoder.v"
`include "Main_Decoder.v"

module Control_Unit_Top (
    input  [6:0] Op, //7 bit opcode
    input  [6:0] funct7, //higher level details (add v sub)
    input  [2:0] funct3, //fine level details (add vs or vs and)

    output        RegWrite, //high if need to save result in register
    output [1:0] ImmSrc, //2 bit, tells cpu how to sign-extend immediate numbers
    output        ALUSrc, //high if ALU needs to use immediate instead of register
    output        MemWrite, //High if writing data to ram (sw)
    output        ResultSrc, //Selects if data going to registers comes from the ALU or RAM
    output        Branch, //high if instruction is branch (beq)
    output [2:0] ALUControl //ALU control from module
);

    wire [1:0] ALUOp;

    // Main control decoder, plugs everything in
    Main_Decoder u_Main_Decoder (
        .Op(Op),
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // ALU control decoder, plugs everything in
    ALU_Decoder u_ALU_Decoder (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7(funct7),
        .op(Op),
        .ALUControl(ALUControl)
    );

endmodule