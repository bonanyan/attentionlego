build: softmax

src/softmax.v: src/softmax.py
	python src/softmax.py > src/softmax.v

src/softmax_tb.v: src/softmax_tb.py
	python src/softmax_tb.py > src/softmax_tb.v

softmax: src/softmax.v src/softmax_tb.v
	iverilog -o wave src/softmax_tb.v 
	vvp -n wave -lxt2

clean:
	rm ./wave*