addi sp, x0, 256      # Initialize Stack
addi a0, x0, 3        # We will count down from 3 to 0
jal ra, 8             # Call Recursive_Down
sw a0, 0(sp)          # Final result stored here
addi x0, x0, 0        # End

# Recursive_Down:
beq a0, x0, 16        # If a0 == 0, skip to the return (Base Case)
addi sp, sp, -8       # Make room on stack
sw ra, 4(sp)          # Save Return Address
sw a0, 0(sp)          # Save current value of a0
addi a0, a0, -1       # Decrement a0
jal ra, -20           # RECURSIVE CALL (Jump back to start of function)
lw a0, 0(sp)          # Restore a0 during unwinding
lw ra, 4(sp)          # Restore ra during unwinding
addi sp, sp, 8        # Clean stack
jalr x0, 0(ra)        # Return