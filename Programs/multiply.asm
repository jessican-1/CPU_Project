addi x10, x0, 3         # Multiplier (A) = 3
addi x12, x0, 4         # Multiplicand (B) = 4
addi x11, x0, 0         

# --- LOOP START ---
beq  x5, x0, 16         
add  x11, x11, x12      
addi x5, x5, -1       
beq  x0, x0, -12        

# --- DONE ---
sw   x11, 8(x0)         
lw   x15, 8(x0)         # Load it to x15