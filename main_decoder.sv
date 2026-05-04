module main_decoder(op, zero, regWrite, MemWrite, ResultSrc, ALUsrc, ImmSrc, ALUOp, PCSrc)
    //opcode from instruction, zero from ALU for branching, regWrite write to register file, MemWrite to memory, ResultSrc where result comes from, ALUSrc ALU input source, ImmSrc, how to interpret immediate, ALUOp is opcode
    input zero;
    input [6:0] op;
    output RegWrite, MemWrite, ResultSrc, PCSrc;
    output[1:0] ImmSrc, ALUop;

    wire branch;
    //7'b0110011 -> R-type, 7'b0000011 → LOAD, 7'b0100011 → STORE, 7'b1100011 → BRANCH
    assign RegWrite = ((op == 7'b0000011) | (op == 7'b0110011)) ? 1'b1 : 1'b0; //add and load
    //Load or R-type
    assign MemWrite = (op == 7'b0100011) ? 1'b1 : 1'b0; 
    //Store
    assign ResultSrc = (op == 7'b0000011) ? 1'b1 : 1'b0;
    //Load
    assign ALUSrc = ((op == 7'b0000011) | (op == 7'b0100011)) ? 1'b1 : 1'b0;
    //Load or Store
    assign branch = (op == 7'b1100011) ? 1'b1 : 1'b0;
    //Branch
    assign ImmSrc = (op == 7'b0100011) ? 2'b01 : (op == 7'b1100011) ? 2'b10 : 2'b00;
    //Store
    assign ALUOp = (op == 7'b0110011) ? 2'b10 : (op == 7'b1100011) ? 2'b01 : 2'b00;
    //R-Type -> 10, Branch -> 01, else -> 00
    assign PCSrc = zero & branch;
    //Jump only if branch and ALU condition is true
endmodule