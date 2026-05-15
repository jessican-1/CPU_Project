addi x10, x0, 3         # Multiplier (A) = 3
addi x12, x0, 4         # Multiplicand (B) = 4
addi x11, x0, 0         # Result = 0
addi x5, x10, 0         # Counter = A (3)

# --- LOOP START ---
beq  x5, x0, 16         # IF Counter == 0, jump to STORE (3 instructions ahead)
add  x11, x11, x12      # Result = Result + B
addi x5, x5, -1         # Counter = Counter - 1
beq  x0, x0, -12        # JUMP back to BEQ (3 instructions back)

# --- DONE ---
sw   x11, 8(x0)         # Store final Result (12) in Memory Address 8
lw   x15, 8(x0)         # Load it back to x15 to verify