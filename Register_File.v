module Register_File(
    input clk, //clock signal
    input rst, //reset signal
    input WE3, //write enable (1 = save data)
    input [4:0]A1, //address of register 1 to read
    input [4:0]A2, //address of register 2 to read
    input [4:0]A3, //address of reg to write to
    input [31:0]WD3, //32 bit data to write
    output [31:0]RD1, //32 bit out 1
    output [31:0]RD2 //32 bit out 2
);
    reg [31:0] Register [31:0]; //32 regs, 32 bits wide each
    integer i;

    // Write Logic + Sync Reset
    always @ (posedge clk)
    begin
        if (~rst) begin
            // Initialize all registers to 0 on reset
            for (i = 0; i < 32; i = i + 1) begin
                Register[i] <= 32'h0;
            end
        end
        else if(WE3 && (A3 != 5'd0)) // Ensure we never overwrite x0, register 0 is always 0
            Register[A3] <= WD3;
    end

    // Read Logic: Hardwire x0 to 0 AND handle reset
    // If A1 is 0, RD1 is ALWAYS 0. If rst is low, output 0.
    assign RD1 = (~rst) ? 32'b0 : //reset low = 0
             (A1 == 5'd0) ? 32'b0 : //register is 0, output 0
             Register[A1]; //else, give value stored in register

    assign RD2 = (~rst) ? 32'b0 :
             (A2 == 5'd0) ? 32'b0 :
             Register[A2];
    //reading is asynch, and same for both registers, rd1 and rd2
endmodule