`include "PC.v"
`include "Instruction_Memory.v"
`include "Register_File.v"
`include "Sign_Extend.v"
`include "ALU.v"
`include "Control_Unit_Top.v"
`include "Data_Memory.v"
`include "PC_Adder.v"
`include "Mux.v"
`include "Cache.v"

module Single_Cycle_Top(clk, rst);

    input clk, rst;

    // Internal Wires
    wire [31:0] PC_Top, RD_Instr, RD1_Top, RD2_Top, Imm_Ext_Top;
    wire [31:0] ALUResult, ReadData, Result, SrcB;
    wire [31:0] PCPlus4, PCTarget, PC_Next; // PC Path Wires
    
    wire RegWrite, MemWrite, ALUSrc, Branch, Zero, PCSrc, Jump;
    wire [1:0] ImmSrc, ResultSrc;
    wire [2:0] ALUControl_Top;

    // Cache wires
    wire [31:0] Cache_RD;
    wire Cache_Hit;
    wire [31:0] Final_Mem_Data;

    // --- PC Logic ---
    
    // PCSrc Decision: Jump if it's a Branch AND the ALU says Zero, or Jump instruction
    assign PCSrc = (Branch & Zero) | Jump;

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

    wire [31:0] Actual_Jump_Target;
    // If Opcode is JALR (1100111), take address from ALU. Else use PC Adder.
    assign Actual_Jump_Target = (RD_Instr[6:0] == 7'b1100111) ? ALUResult : PCTarget;

    // Mux to select between PC+4 or Branch Target
    Mux PC_Mux(
        .a(PCPlus4),
        .b(Actual_Jump_Target),
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
        .Jump(Jump),
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

    // Cache
    Cache Data_Cache(
        .clk(clk), .rst(rst), .Address(ALUResult), .WriteData(RD2_Top),
        .WE(MemWrite), .ReadData(Cache_RD), .Hit(Cache_Hit)
    );
    
    //hit/miss
    assign Final_Mem_Data = (Cache_Hit) ? Cache_RD : ReadData;

    // Select between ALU Result, Memory Data, or PC+4 Register Writeback
    assign Result = (ResultSrc == 2'b10) ? PCPlus4 : 
                    (ResultSrc == 2'b01) ? ReadData : // Final_Mem_Data is incorrect 
                    ALUResult;

    /*
    Mux Mux_DataMemory_to_Register(
        .a(ALUResult),
        .b(ReadData),
        .s(ResultSrc),
        .c(Result)
    );
    */

endmodule