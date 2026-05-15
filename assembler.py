import re

def assemble(asm_line):
    # Standard Opcodes
    OP_R, OP_I, OP_B, OP_LOAD, OP_STORE, OP_JAL, OP_JALR = 0b0110011, 0b0010011, 0b1100011, 0b0000011, 0b0100011, 0b1101111, 0b1100111    
    
    # Register Alias Mapping
    reg_map = {
        'zero': 0, 'ra': 1, 'sp': 2, 'gp': 3, 'tp': 4,
        't0': 5, 't1': 6, 't2': 7, 's0': 8, 'fp': 8, 's1': 9,
        'a0': 10, 'a1': 11, 'a2': 12, 'a3': 13, 'a4': 14, 'a5': 15,
        'a6': 16, 'a7': 17, 's2': 18, 's3': 19, 's4': 20, 's5': 21,
        's6': 22, 's7': 23, 's8': 24, 's9': 25, 's10': 26, 's11': 27,
        't3': 28, 't4': 29, 't5': 30, 't6': 31
    }

    # Add x0-x31 to the map
    for i in range(32): reg_map[f'x{i}'] = i


    # 1. Clean the line: remove comments and get the instruction name
    line = re.sub(r'#.*', '', asm_line).strip().lower()
    if not line or line.endswith(':'): return None # Skip empty lines and standalone labels
    
    # Clean up delimiters to make splitting easy
    line = line.replace(',', ' ').replace('(', ' ').replace(')', ' ')
    parts = line.split()
    if not parts: return None

    inst = parts[0]
    
    def get_val(s):
        if s in reg_map: return reg_map[s]
        match = re.search(r'-?\d+', s)
        if match: return int(match.group())
        return 0 # Fallback for labels (requires manual offset for now)

    try:
        
        # R-TYPE: add rd, rs1, rs2
        if inst in ['add', 'sub']:
            rd, rs1, rs2 = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            f3, f7 = 0, (0b0100000 if inst == 'sub' else 0)
            res = (f7 << 25) | (rs2 << 20) | (rs1 << 15) | (f3 << 12) | (rd << 7) | OP_R
            
        # I-TYPE: addi rd, rs1, imm
        elif inst == 'addi':
            rd, rs1, imm = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            res = ((imm & 0xFFF) << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | OP_I

        # B-TYPE: beq rs1, rs2, imm
        elif inst == 'beq':
            if len(parts) < 3:
                print(f"Error: 'beq' needs an integer offset, but found a label or text.")
                return None
            rs1, rs2, imm = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            # RISC-V B-type immediate encoding
            res = (((imm >> 12) & 0x1) << 31) | \
                  (((imm >> 5) & 0x3F) << 25) | \
                  (rs2 << 20) | (rs1 << 15) | (0 << 12) | \
                  (((imm >> 1) & 0xF) << 8) | \
                  (((imm >> 11) & 0x1) << 7) | OP_B

        # S-TYPE: sw rs2, imm(rs1)
        elif inst == 'sw':
            rs2, imm, rs1 = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            imm_val = imm & 0xFFF
            # Split imm into [11:5] and [4:0]
            res = ((imm_val >> 5) << 25) | (rs2 << 20) | (rs1 << 15) | (2 << 12) | ((imm_val & 0x1F) << 7) | OP_STORE

        # I-TYPE LOAD: lw rd, imm(rs1)
        elif inst == 'lw':
            rd, imm, rs1 = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            res = ((imm & 0xFFF) << 20) | (rs1 << 15) | (2 << 12) | (rd << 7) | OP_LOAD
        
        # JAL: jal rd, imm (Note: imm is byte offset)
        elif inst == 'jal':
            rd, imm = get_val(parts[1]), get_val(parts[2])
            imm_bit = ((imm >> 20) & 0x1) << 31 | ((imm >> 1) & 0x3FF) << 21 | \
                      ((imm >> 11) & 0x1) << 20 | ((imm >> 12) & 0xFF) << 12
            res = imm_bit | (rd << 7) | OP_JAL

        # JALR: jalr rd, imm(rs1)
        elif inst == 'jalr':
            rd, imm, rs1 = get_val(parts[1]), get_val(parts[2]), get_val(parts[3])
            res = ((imm & 0xFFF) << 20) | (rs1 << 15) | (0 << 12) | (rd << 7) | OP_JALR

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