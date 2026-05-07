module Reg_file(
    input clk,
    input rst,
    input WE3,
    input [4:0] A1, A2, A3,
    input [31:0] WD3,
    output [31:0] RD1, RD2
);

    reg [31:0] Registers [31:0];

    // read
    assign RD1 = Registers[A1];
    assign RD2 = Registers[A2];

    // write
    always @(posedge clk) begin
        if (rst) begin
            integer i;
            for (i = 0; i < 32; i = i + 1)
                Registers[i] <= 32'b0;
        end
        else if (WE3) begin
            Registers[A3] <= WD3;
        end
    end
    // add x3, x1, x2 => RD1 = Registers[x1], RD2 = Registers[x2]

endmodule