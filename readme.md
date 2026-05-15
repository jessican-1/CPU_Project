#VIDEO DEMONSTRATION FOR EC:
https://drive.google.com/drive/folders/1bte9kv8f_ksPxGPG4Qw7CtXQ50jort4-?usp=sharing

# RISC-Based CPU Implementation

A custom RISC-V inspired single-cycle CPU architecture. This project implements a functional datapath including an ALU, Control Unit, Register File, and Data Memory, based on the principles outlined in the "RISC-V: From Transistors to AI" series.


## Simplfied CPU Diagram
![alt text](<Final project.png>)


## Waveform Diagram
![alt text](<Waveform.png>)

## Project Overview

This repository contains the hardware description (Verilog/SystemVerilog) for a single-cycle RISC-V CPU and a custom Python-based assembler to bridge the gap between human-readable assembly and machine code.

### Key Features:
- **Single-Cycle Datapath:** Simplified execution flow where each instruction completes in one clock cycle.
- **Python Assembler:** Automatically translates `.asm` files into `.hex` files for memory initialization.
- **Simulation Ready:** Setup for simulation using Icarus Verilog and visualization via GTKWave.

---

## Supported Instruction Set

The CPU supports a subset of the RISC-V RV32I base integer instruction set.

| Instruction | Type | Opcode | Description |
| :--- | :---: | :---: | :--- |
| `add`, `sub` | R | `0110011` | Arithmetic operations between registers |
| `and`, `or`, `slt`| R | `0110011` | Logical and Set-Less-Than operations |
| `addi` | I | `0010011` | Add immediate value to a register |
| `lw` | I | `0000011` | Load 32-bit word from Memory to Register |
| `sw` | S | `0100011` | Store 32-bit word from Register to Memory |
| `beq` | B | `1100011` | Branch to offset if registers are equal |

### Instruction Formats

* **R-type:** `[funct7] [rs2] [rs1] [funct3] [rd] [opcode]`
* **I-type:** `[imm[11:0]] [rs1] [funct3] [rd] [opcode]`
* **S-type:** `[imm[11:5]] [rs2] [rs1] [funct3] [imm[4:0]] [opcode]`
* **B-type:** `[imm[12]] [imm[10:5]] [rs2] [rs1] [funct3] [imm[4:1]] [imm[11]] [opcode]`

---

## Getting Started

### Prerequisites
- Python 3.x (for the assembler)
- Icarus Verilog (for simulation)
- GTKWave (for waveform visualization)
- Make (for build automation)

### Testing a Program

1.  **Write Assembly:** Paste your code into `program.asm`. You can find examples in the `Programs/` folder.
2.  **Assemble:** Run the Python script to generate the machine code.
    ```bash
    python3 assembler.py
    ```
3.  **Compile & Simulate:** Use the provided Makefile to compile the Verilog source and run the simulation.
    ```bash
    make
    ```
4.  **Visualize:** Open the resulting waveform to verify the CPU behavior.
    ```bash
    make wave
    ```

### Verification Checklist
When viewing waveforms in **GTKWave**, monitor the following signals:
- **ALUResult:** Ensure arithmetic results match expected values.
- **Register File:** Verify that `rd` is updated correctly on write-back.
- **Data Memory:** For `lw` and `sw`, check the `Data_Memory` signals (address, write-enable, and data-in/out) to confirm correct interaction with the memory array.

---

## Project Structure
- `/Programs`: Contains example `.asm` files for testing.
- `assembler.py`: Python tool to convert assembly to hex.
- `program.asm`: The main input file for the assembler.
- `*.v`: Verilog source files for CPU modules (ALU, Control Unit, etc.).
- `Makefile`: Script to automate the build and simulation process.

---

## Acknowledgments
Inspired by the YouTube series *"RISC-V: From Transistors to AI"*.