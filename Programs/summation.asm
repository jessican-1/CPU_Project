addi x11, x0, 0        # Start result at 0
addi x5, x10, 5        # Set counter to 5
# --- LOOP START ---
beq  x5, x0, 12        
add  x11, x11, x5      
addi x5, x5, -1       
beq  x0, x0, -12       
# --- DONE ---
sw   x11, 8(x0)        # Store final in memory
