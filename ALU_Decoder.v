module ALU_Decoder (
    input  [1:0] ALUOp, //2 bit category control from main control
    input  [2:0] funct3, //funct3 from instruction bits 14:12
    input  [6:0] funct7, //funct7 from instruction bits 31:25
    input  [6:0] op, //opcode bits 6:0
    output reg [2:0] ALUControl //final 3 bit command, to go to ALU
);

    always @(*) begin
        case (ALUOp)

            // Load/Store -> ADD, for lw or sw, need to calculate address + offset
            2'b00: ALUControl = 3'b000;

            // Branch -> SUB, for branching, must check if sub instruction results in 0
            2'b01: ALUControl = 3'b001;

            // R-type / I-type
            2'b10: begin
                case (funct3)

                    // ADD / SUB
                    3'b000: begin  //add and sub have funct3 of 000 in RISC
                        if ({op[5], funct7[5]} == 2'b11) //checks for two specific bits, to determine + or -
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD, covers both add and addi
                    end

                    //following maps to typical SLT, OR, and AND in the ALU
                    // SLT
                    3'b010: ALUControl = 3'b101;

                    // OR
                    3'b110: ALUControl = 3'b011;

                    // AND
                    3'b111: ALUControl = 3'b010;

                    default: ALUControl = 3'b000;
                endcase
            end

            default: ALUControl = 3'b000; //defaults to 000, add
        endcase
    end

endmodule