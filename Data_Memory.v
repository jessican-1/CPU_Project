module Data_Memory (
    input         clk,
    input         rst,
    input         WE,
    input  [31:0] A,
    input  [31:0] WD,
    output [31:0] RD
);

    reg [31:0] mem [0:1023];

    // Word-aligned address (A/4)
    wire [9:0] addr;
    assign addr = A[11:2];

    // Write operation
    always @(posedge clk) begin
        if (WE)
            mem[addr] <= WD;
    end

    // Read operation - Removed the rst dependency that was zeroing the output
    assign RD = mem[addr]; 

    // Initial memory values for testing
    initial begin
         // This is Address 8 (8/4 = 2)
        mem[7] = 32'h00000020; // This is Address 28 (28/4 = 7)
    end

endmodule