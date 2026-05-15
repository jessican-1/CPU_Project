addi sp, x0, 256      # Initialize Stack Pointer
addi a0, x0, 2        # Argument a0 = 2
jal ra, 12            # Call Outer_Func (Jump forward 12 bytes)
sw a0, 0(sp)          # [Return Point] Store final result (4)
beq x0, x0, 0        # End

# Outer_Func:
addi sp, sp, -4       # Move Stack Down
sw ra, 0(sp)          # SAVE ra to Stack
jal ra, 16          # Call Inner_Func (Jump forward 12 bytes)
lw ra, 0(sp)          # RESTORE ra from Stack
addi sp, sp, 4        # Move Stack Up
jalr x0, 0(ra)        # Return to main program

# Inner_Func:
addi a0, a0, 2        # Just adds 2
jalr x0, 0(ra)        # Return to Outer_Func