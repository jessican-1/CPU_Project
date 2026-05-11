module Instruction_Memory(

  input rst, //reset signal
  input [31:0]A, //address (PC)
  output [31:0]RD //read data (actual instruction that comes out)
);
  reg [31:0] mem [1023:0]; //1024 instructions, 32 bits each
  
  assign RD = (~rst) ? {32{1'b0}} : mem[A[31:2]]; //if reset = 0, output is all 0, otherwise, returns memory at address

  initial begin
    $readmemh("program.hex",mem); //actual program is inputted
  end



endmodule