module ALU (
    input [7:0] a, b,
    input [2:0] op,
    output reg [7:0] y,
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
assign n = y[7];    //negative
assign c = cout;    //unsigned overflow, carry out
assign v = (a[7] == b[7]) && (y[7] != a[7]);//signed overflow (1+127 -> -128)

endmodule