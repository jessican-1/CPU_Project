import re

def assemble(asm_line):
    # Standard Opcodes
    OP_R, OP_I, OP_B, OP_LOAD, OP_STORE = 0b0110011, 0b0010011, 0b1100011, 0b0000011, 0b0100011
    
    # 1. Clean the line: remove comments and get the instruction name
    clean_line = re.sub(r'#.*', '', asm_line).strip().lower()
    if not clean_line: return None
    
    parts = clean_line.split()
    inst = parts[0]
    
    try:
        # --- THE FIX: Define 'nums' by extracting all integers ---
        # This finds '7', '8', and '0' from 'sw x7, 8(x0)'
        nums = [int(n) for n in re.findall(r'-?\d+', clean_line)]
        
        # R-TYPE: add rd, rs1, rs2
        if inst in ['add', 'sub']:
            rd, rs1, rs2 = nums[0], nums[1], nums[2]
            f3, f7 = 0, (0b0100000 if inst == 'sub' else 0)
            res = (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | OP_R
            
        # I-TYPE: addi rd, rs1, imm
        elif inst == 'addi':
            rd, rs1, imm = nums[0], nums[1], nums[2]
            res = ((imm & 0xFFF) << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | OP_I

        # B-TYPE: beq rs1, rs2, imm
        elif inst == 'beq':
            if len(nums) < 3:
                print(f"Error: 'beq' needs an integer offset, but found a label or text.")
                return None
            rs1, rs2, imm = nums[0], nums[1], nums[2]
            # RISC-V B-type immediate encoding
            res = (((imm >> 12) & 0x1) << 31) | \
                  (((imm >> 5) & 0x3F) << 25) | \
                  (rs2 << 20) | (rs1 << 15) | (0 << 12) | \
                  (((imm >> 1) & 0xF) << 8) | \
                  (((imm >> 11) & 0x1) << 7) | OP_B

        # S-TYPE: sw rs2, imm(rs1)
        elif inst == 'sw':
            rs2, imm, rs1 = nums[0], nums[1], nums[2]
            imm_val = imm & 0xFFF
            # Split imm into [11:5] and [4:0]
            res = ((imm_val >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | ((imm_val & 0x1F) << 7) | OP_STORE

        # I-TYPE LOAD: lw rd, imm(rs1)
        elif inst == 'lw':
            rd, imm, rs1 = nums[0], nums[1], nums[2]
            res = ((imm & 0xFFF) << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | OP_LOAD
        
        else:
            return None

        return f"{res:08x}"

    except Exception as e:
        print(f"Error parsing line '{asm_line.strip()}': {e}")
        return None

# Main execution
print("Starting assembly...")
with open("program.asm", "r") as f_in, open("program.hex", "w") as f_out:
    for line in f_in:
        hex_code = assemble(line)
        if hex_code:
            print(f"Assembled: {line.strip()} -> {hex_code}")
            f_out.write(hex_code + "\n")
print("Done! Check program.hex")