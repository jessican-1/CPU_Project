addi sp, x0, 256    # Initialize Stack Pointer
    addi a0, x0, 5      # Test value
    jal ra, test_func   # Test JAL and Link logic
    sw a0, 0(sp)        # Test Cache (Store)
    lw t0, 0(sp)        # Test Cache (Load Hit)
    
test_func:
    addi a0, a0, 1
    jalr x0, 0(ra)      # Test JALR return logic