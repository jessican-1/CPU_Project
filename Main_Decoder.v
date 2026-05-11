module Main_Decoder(
    input [6:0]Op, //takes opcode in
    output RegWrite, //-> write enable of register file, if 1, result saved to register. Else, no save.
    output ALUSrc, //-> alu 2nd input, mux right before ALU. If 0, streams data from 2nd register. If 1, streams data from immediate
    output MemWrite, //-> write enable of RAM. only on during sw
    output ResultSrc, //-> mux at end of datapath. 0 = data to registers from ALU, 1 = from memory (lw)
    output Branch, //->and gate controlling PC source. if ALU is 0, jump to branch instead of next line
    output [1:0]ImmSrc,ALUOp //immsrc->extend unit: immediate generator, tells cpu to unpack constant from 32 bit instruction
    //ALUOp: ALU_Decoder modcule, 2 bit summary to second decoder to pick math operation
);

    assign RegWrite = (Op == 7'b0000011 | Op == 7'b0110011 | Op == 7'b0010011) ? 1'b1 : 1'b0; //1 for load, r-type math, and i-type math. 0 for branches or stores, don't change register values 
    assign ImmSrc = (Op == 7'b0100011) ? 2'b01 : //if s-type, return 01..
                (Op == 7'b1100011) ? 2'b10 : 2'b00; //..and if B type, turn 10, and 00 for I type/default
    assign ALUSrc = (Op == 7'b0000011 | Op == 7'b0100011 | Op == 7'b0010011) ? 1'b1 : 1'b0; //register(0) or immediate(1)
    assign MemWrite = (Op == 7'b0100011) ? 1'b1 :
                                           1'b0 ;//if store instruction, = 1
    assign ResultSrc = (Op == 7'b0000011) ? 1'b1 :
                                            1'b0 ;//if lw, send result to mem instead of register
    assign Branch = (Op == 7'b1100011) ? 1'b1 :
                                         1'b0 ;//for b type instructions, if hi, branch
    assign ALUOp = (Op == 7'b0110011) ? 2'b10 ://10 - r type, complex math
                   (Op == 7'b1100011) ? 2'b01 ://01 - branch, force subtract
                                        2'b00 ;//00 - load/store, addition

endmodule