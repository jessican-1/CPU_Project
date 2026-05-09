module Register_File(
    input clk,
    input rst,
    input WE3,
    input [4:0]A1,
    input [4:0]A2,
    input [4:0]A3,
    input [31:0]WD3,
    output [31:0]RD1,
    output [31:0]RD2
);
    reg [31:0] Register [31:0];
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
        else if(WE3 && (A3 != 5'd0)) // Ensure we never overwrite x0
            Register[A3] <= WD3;
    end

    // Read Logic: Hardwire x0 to 0 AND handle reset
    // If A1 is 0, RD1 is ALWAYS 0. If rst is low, output 0.
    assign RD1 = (~rst) ? 32'b0 :
             (A1 == 5'd0) ? 32'b0 :
             Register[A1];

    assign RD2 = (~rst) ? 32'b0 :
             (A2 == 5'd0) ? 32'b0 :
             Register[A2];

endmodule