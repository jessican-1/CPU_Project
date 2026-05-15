addi sp, x0, 256      # Initialize Stack Pointer
addi a0, x0, 10       # Load argument a0 = 10
jal ra, 8             # Call Leaf_Add (Jump forward 8 bytes)
sw a0, 0(sp)          # [Return Point] Store result (15) in Memory/Cache
addi x0, x0, 0        # End of program (NOP)

# Leaf_Add: Adds 5 to the input
addi a0, a0, 5        # a0 = a0 + 5
jalr x0, 0(ra)        # Return to caller