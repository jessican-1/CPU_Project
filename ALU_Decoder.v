module ALU_Decoder (
    input  [1:0] ALUOp,
    input  [2:0] funct3,
    input  [6:0] funct7,
    input  [6:0] op,
    output reg [2:0] ALUControl
);

    always @(*) begin
        case (ALUOp)

            // Load/Store -> ADD
            2'b00: ALUControl = 3'b000;

            // Branch -> SUB
            2'b01: ALUControl = 3'b001;

            // R-type / I-type
            2'b10: begin
                case (funct3)

                    // ADD / SUB
                    3'b000: begin
                        if ({op[5], funct7[5]} == 2'b11)
                            ALUControl = 3'b001; // SUB
                        else
                            ALUControl = 3'b000; // ADD
                    end

                    // SLT
                    3'b010: ALUControl = 3'b101;

                    // OR
                    3'b110: ALUControl = 3'b011;

                    // AND
                    3'b111: ALUControl = 3'b010;

                    default: ALUControl = 3'b000;
                endcase
            end

            default: ALUControl = 3'b000;

        endcase
    end

endmodule