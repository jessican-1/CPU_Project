`timescale 1ns / 1ps
module Single_Cycle_Top_Tb ();
    
    reg clk=1'b1,rst;

    Single_Cycle_Top dut(
        .clk(clk),
        .rst(rst)
    );


    initial begin
        $dumpfile("dump.vcd");
        $dumpvars(0, Single_Cycle_Top_Tb);
        $dumpvars(0, dut.Register_File.Register[0]);
        $dumpvars(0, dut.Register_File.Register[1]);
        $dumpvars(0, dut.Register_File.Register[2]);
        $dumpvars(0, dut.Register_File.Register[3]);
        $dumpvars(0, dut.Register_File.Register[4]);
        $dumpvars(0, dut.Register_File.Register[5]);
        $dumpvars(0, dut.Register_File.Register[6]);
        $dumpvars(0, dut.Register_File.Register[7]);
        $dumpvars(0, dut.Register_File.Register[8]);
        $dumpvars(0, dut.Register_File.Register[9]);
        $dumpvars(0, dut.Register_File.Register[10]);
        $dumpvars(0, dut.Register_File.Register[11]);
        $dumpvars(0, dut.Register_File.Register[12]);
        $dumpvars(0, dut.Register_File.Register[13]);
        $dumpvars(0, dut.Register_File.Register[14]);
        $dumpvars(0, dut.Register_File.Register[15]);
        $dumpvars(0, dut.Register_File.Register[16]);
        $dumpvars(0, dut.Register_File.Register[17]);
        $dumpvars(0, dut.Register_File.Register[18]);
        $dumpvars(0, dut.Register_File.Register[19]);
        $dumpvars(0, dut.Register_File.Register[20]);
        $dumpvars(0, dut.Register_File.Register[21]);
        $dumpvars(0, dut.Register_File.Register[22]);
        $dumpvars(0, dut.Register_File.Register[23]);
        $dumpvars(0, dut.Register_File.Register[24]);
        $dumpvars(0, dut.Register_File.Register[25]);
        $dumpvars(0, dut.Register_File.Register[26]);
        $dumpvars(0, dut.Register_File.Register[27]);
        $dumpvars(0, dut.Register_File.Register[28]);
        $dumpvars(0, dut.Register_File.Register[29]);
        $dumpvars(0, dut.Register_File.Register[30]);
        $dumpvars(0, dut.Register_File.Register[31]);
        $dumpvars(0, dut.Data_Memory.mem[16]);
        $dumpvars(0, dut.Data_Memory.mem[17]);
    end


    always 
    begin
        clk = ~ clk;
        #50;  
        
    end



    
    initial
    begin
        rst <= 1'b0;
        #150;

        rst <=1'b1;
        #7500;
        $finish;
    end
    
endmodule