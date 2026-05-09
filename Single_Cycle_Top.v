`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"

module Single_Cycle_Top(clk, rst);

    input clk, rst;

    // Internal Wires
    wire [31:0] PC_Top, RD_Instr, RD1_Top, RD2_Top, Imm_Ext_Top;
    wire [31:0] ALUResult, ReadData, Result, SrcB;
    wire [31:0] PCPlus4, PCTarget, PC_Next; // PC Path Wires
    
    wire RegWrite, MemWrite, ALUSrc, ResultSrc, Branch, Zero, PCSrc;
    wire [1:0] ImmSrc;
    wire [2:0] ALUControl_Top;

    // --- PC Logic ---
    
    // PCSrc Decision: Jump if it's a Branch AND the ALU says Zero
    assign PCSrc = Branch & Zero;

    // Standard PC+4 Adder
    PC_Adder PC_Adder_Plus4(
        .a(PC_Top),
        .b(32'd4),
        .c(PCPlus4)
    );

    // Branch Target Adder (PC + Imm_Ext)
    PC_Adder PC_Adder_Target(
        .a(PC_Top),
        .b(Imm_Ext_Top),
        .c(PCTarget)
    );

    // Mux to select between PC+4 or Branch Target
    Mux PC_Mux(
        .a(PCPlus4),
        .b(PCTarget),
        .s(PCSrc),
        .c(PC_Next)
    );

    // The actual PC Register
    PC_Module PC(
        .clk(clk),
        .rst(rst),
        .PC(PC_Top),
        .PC_Next(PC_Next)
    );

    // --- Instruction & Data Paths ---

    Instruction_Memory Instruction_Memory(
        .rst(rst),
        .A(PC_Top),
        .RD(RD_Instr)
    );

    Register_File Register_File(
        .clk(clk),
        .rst(rst),
        .WE3(RegWrite),
        .WD3(Result),
        .A1(RD_Instr[19:15]),
        .A2(RD_Instr[24:20]),
        .A3(RD_Instr[11:7]),
        .RD1(RD1_Top),
        .RD2(RD2_Top)
    );

    // Connected full 2-bit ImmSrc
    Sign_Extend Sign_Extend(
        .In(RD_Instr),
        .ImmSrc(ImmSrc), 
        .Imm_Ext(Imm_Ext_Top)
    );

    // Select between Register RD2 or Immediate for ALU input
    Mux Mux_Register_to_ALU(
        .a(RD2_Top),
        .b(Imm_Ext_Top),
        .s(ALUSrc),
        .c(SrcB)
    );

    ALU ALU(
        .A(RD1_Top),
        .B(SrcB),
        .ALUControl(ALUControl_Top),
        .Result(ALUResult),
        .Zero(Zero), // Connected to PCSrc Logic
        .OverFlow(),
        .Carry(),
        .Negative()
    );

    Control_Unit_Top Control_Unit_Top(
        .Op(RD_Instr[6:0]),
        .funct3(RD_Instr[14:12]),
        .funct7(RD_Instr[31:25]), // Fixed: funct7 is usually top bits
        .RegWrite(RegWrite),
        .ImmSrc(ImmSrc),
        .ALUSrc(ALUSrc),
        .MemWrite(MemWrite),
        .ResultSrc(ResultSrc),
        .Branch(Branch), // Connected to PCSrc Logic
        .ALUControl(ALUControl_Top)
    );

    Data_Memory Data_Memory(
        .clk(clk),
        .rst(rst),
        .WE(MemWrite),
        .A(ALUResult),
        .WD(RD2_Top),
        .RD(ReadData)
    );

    // Select between ALU Result or Memory Data for Register Writeback
    Mux Mux_DataMemory_to_Register(
        .a(ALUResult),
        .b(ReadData),
        .s(ResultSrc),
        .c(Result)
    );

endmodule