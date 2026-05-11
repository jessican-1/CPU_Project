module PC_Module(
    input clk, //clock
    input rst, //reset (1 = run, 0 = reset)
    input [31:0]PC_Next, //next address
    output reg [31:0]PC //address we are at
);

    always @(posedge clk) //ignore everything until postive edge
    begin
        if(~rst)
            PC <= 32'b0; //if reset = 0, start at 0 address
        else
            PC <= PC_Next;//otherwise, continue
    end

endmodule