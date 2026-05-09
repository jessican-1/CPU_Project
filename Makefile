IVERILOG = iverilog
VVP = vvp
GTKWAVE = gtkwave

OUT = cpu.out

TOP = Single_Cycle_Top_Tb
SRC = Single_Cycle_Top.v
TB = Single_Cycle_Top_Tb.v

all: run

compile:
	$(IVERILOG) -g2012 -s $(TOP) -o $(OUT) $(SRC) $(TB)

run: compile
	$(VVP) $(OUT)

wave: run
	$(GTKWAVE) dump.vcd

clean:
	del /Q $(OUT) *.vcd 2>nul

.PHONY: all compile run wave clean