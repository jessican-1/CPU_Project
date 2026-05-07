module ALU (
    input [31:0] a, b,
    input [2:0] op,
    output reg [31:0] y,
    output z,
    output n,
    output c,
    output v
);

reg cout;

always @(*) begin
    case(op)
        3'b000: {cout, y} = a + b;
        3'b001: {cout, y} = a - b;
        3'b010: y = a & b;
        3'b011: y = a | b;
        3'b100: y = (a < b);
        default: y = 0;
    endcase
end

assign z = (y == 0); //zero
assign n = y[31];    //negative
assign c = cout;    //unsigned overflow, carry out
assign v = (a[31] == b[31]) && (y[31] != a[31]);//signed overflow (1+127 -> -128)

endmodule