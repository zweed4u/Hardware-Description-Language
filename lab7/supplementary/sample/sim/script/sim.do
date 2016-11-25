vlib work
vcom -93 -work work ../../src/sample.vhd
vcom -93 -work work ../src/sample_tb.vhd
vsim -novopt -msgmode both sample_tb
do wave.do
run 500 ns