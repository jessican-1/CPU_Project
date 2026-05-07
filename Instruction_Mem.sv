module Instr_Mem(
    input [31:0] a,
    input rst,
    output [31:0] RD
);

    reg [31:0] Mem [1023:0];

    assign RD = (rst) ? 32'b0 : Mem[a[11:2]];

    initial begin
        $readmemh("memfile.hex", Mem);
    end

endmodule