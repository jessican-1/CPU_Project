addi x5, x0, 3      # x5 = 3  
addi x6, x0, 0      # x6 = 0  
addi x7, x0, 1      # x7 = 1  

# Loop Start
add  x6, x6, x5     # x6 = x6 + x5  
sub  x5, x5, x7     # x5 = x5 - 1   
beq x5, x0, 8       # (exit loop)
beq  x0, x0, -12    # Jump back 12 bytes 

# Final result should be in x6
addi x8, x6, 0      #Move final sum to x8 to see it clearly