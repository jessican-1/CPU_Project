module Data_Memory (
    input         clk, //clock signal (writes on rising edge)
    input         rst, //reset signal
    input         WE, //write enable (high = store, low = load)
    input  [31:0] A, //Memory address
    input  [31:0] WD, //Write data (data to store)
    output [31:0] RD //Read data (data we are reading)
);

    reg [31:0] mem [0:1023]; //1024 slots of 32 bit wide memory (4kb)

    // Word-aligned address (A/4)
    wire [9:0] addr;
    assign addr = A[11:2]; //4 bytes per word, but each byte gets an address, so word addresses are the top few bits 

    // Write operation, synchonous on clock edge
    always @(posedge clk) begin
        if (WE)
            mem[addr] <= WD;//on a positive edge, write to the address if WE is high
    end

    // Read operation - Removed the rst dependency that was zeroing the output 
    assign RD = mem[addr]; //asynchronous

    // Initial memory values for testing
    initial begin
         // This is Address 8 (8/4 = 2)
        mem[7] = 32'h00000020; // This is Address 28 (28/4 = 7)
    end

endmodule