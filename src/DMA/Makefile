all:
	iverilog -o build/dma.vvp src/dma_tb.v
	vvp src/dma.vvp
	gtkwave build/dma_tb.vcd

clean:
	rm -rf build/