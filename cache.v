module Cache (
    input clk,
    input rst,
    input [31:0] Address,    // From ALU
    input [31:0] WriteData,  // From Register File (RD2)
    input WE,                // MemWrite from Control Unit
    output [31:0] ReadData,  // Data sent back to Result Mux
    output Hit               // Tells us if the data was in Cache
);
    // 64 slots: each slot has 32-bit data and a 20-bit tag
    reg [31:0] cache_data [63:0];
    reg [19:0] cache_tags [63:0];
    reg [63:0] valid_bits;

    // Address Decoding: [Tag (20 bits) | Index (6 bits) | Offset (2 bits) | Byte (2 bits)]
    wire [5:0] index = Address[9:4]; 
    wire [19:0] tag = Address[29:10];

    // Combinational Read
    assign Hit = (valid_bits[index] && (cache_tags[index] == tag));
    assign ReadData = cache_data[index];

    // Sequential Write (Write-Through)
    integer i;
    always @(posedge clk) begin
        if (~rst) begin
            valid_bits <= 64'b0;
        end else if (WE) begin
            cache_data[index] <= WriteData;
            cache_tags[index] <= tag;
            valid_bits[index] <= 1'b1;
        end
    end
endmodule