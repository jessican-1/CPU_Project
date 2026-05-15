module Main_Decoder(
    input [6:0]Op, //takes opcode in
    output RegWrite, //-> write enable of register file, if 1, result saved to register. Else, no save.
    output ALUSrc, //-> alu 2nd input, mux right before ALU. If 0, streams data from 2nd register. If 1, streams data from immediate
    output MemWrite, //-> write enable of RAM. only on during sw
    output [1:0] ResultSrc, //-> mux at end of datapath. 0 = data to registers from ALU, 1 = from memory (lw) ~~ updated for Link
    output Branch, //->and gate controlling PC source. if ALU is 0, jump to branch instead of next line
    output Jump, //for JAL/JALR
    output [1:0]ImmSrc,ALUOp //immsrc->extend unit: immediate generator, tells cpu to unpack constant from 32 bit instruction
    //ALUOp: ALU_Decoder modcule, 2 bit summary to second decoder to pick math operation
);

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011 | 
                       Op == 7'b1101111 | Op == 7'b1100111) ? 1'b1 : 1'b0; //1 for load, r-type math, i-type math, and jumps. 0 for branches or stores, don't change register values   

    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : // S-type
                    (Op == 7'b1100011) ? 2'b10 : // B-type
                    (Op == 7'b1101111) ? 2'b11 : // J-type (JAL)
                    2'b00;                       // I-type/default

    //ALUSrc: 1 for Imm (Loads, Stores, I-type, JALR), 0 for Registers
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011 | Op == 7'b1100111) ? 1'b1 : 1'b0; 

    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;//if store instruction, = 1

    assign ResultSrc = (Op == 7'b0000011) ? 2'b01 : // Load
                       (Op == 7'b1101111 | Op == 7'b1100111) ? 2'b10 : // Jumps
                       2'b00;                       // ALU Result

    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;//for b type instructions, if hi, branch

    assign Jump = (Op == 7'b1101111 | Op == 7'b1100111) ? 1'b1 : 1'b0; //if jump instruction, goes high

    assign ALUOp = (Op == 7'b0110011) ? 2'b10 ://10 - r type, complex math
                   (Op == 7'b1100011) ? 2'b01 ://01 - branch, force subtract
                                        2'b00 ;//00 - load/store/jump, addition

endmodule