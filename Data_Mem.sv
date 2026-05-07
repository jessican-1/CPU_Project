module Data_Memory(
    input [31:0] A,
    input [31:0] WD,
    input clk,
    input WE,
    output [31:0] RD
);

    reg [31:0] Data_MEM [1023:0];

    assign RD = (WE == 1'b0) ? Data_MEM[A] : 32'h0;

    always @(posedge clk) begin
        if (WE)
            Data_MEM[A] <= WD;
    end

endmodule