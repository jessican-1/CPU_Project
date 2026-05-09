#Overview: RISC-Based CPU
    This project implements a RISC-based CPU inspired by RISC-V: From Transistors to AI on YouTube. The architecture features a single-cycle RISC-V datapath, including:
        ALU (Arithmetic Logic Unit)

        Control Unit

        Register File

        Data Memory

    The assembler, written in Python, translates assembly code into machine instructions. Example programs are provided in the Programs folder.
    How to Test:
        1. paste the code into program.asm. 
        2. Run the assembler to generate program.hex. 
        3. Run the simulation and check ALUResult and the Register File outputs in GTKWave. 4. For Load/Store operations, monitor the Data_Memory signals to ensure data is correctly written to and read from the memory array.

#Supported Instruction Table 
    | Instruction | Type | Opcode   | Description                             |
    |------------|------|----------|-----------------------------------------|
    | add, sub   | R    | 0110011  | Arithmetic operations between registers |
    | addi       | I    | 0010011  | Add immediate to register               |
    | lw         | I    | 0000011  | Load 32-bit word from Memory to Register |
    | sw         | S    | 0100011  | Store 32-bit word from Register to Memory |
    | beq        | B    | 1100011  | Branch if equal                          |

#instructions
    R-type 
        Instructions: add, sub, and, or slt

        Format: [funct7] [rs2] [rs1] [funct3] [rd] [opcode]

    I-type
        Instruction: addi, lw
        
        Format: [imm12] [rs1] [funct3] [rd] [opcode]

    S-Type
        Instruction: sw

        Format: [imm7] [rs2] [rs1] [funct3] [imm5] [opcode]

    B-Type
        Instructions: beq 

        Format: [imm] [rs2] [rs1] [funct3] [imm] [opcode]

#Compilation steps:
    python3 assembler.py
    make
    make wave
