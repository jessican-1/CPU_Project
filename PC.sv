module PC_Module(
    input [31:0] PC_NEXT;
    input clk, rst;

    output reg [31:0] PC;
);

always @(posedge clk)
begin
    if(rst == 1'b0)
    begin
        PC <= 32'h0;
    end
    else
    begin
        PC <= PC_NEXT;
    end 
end

endmodule