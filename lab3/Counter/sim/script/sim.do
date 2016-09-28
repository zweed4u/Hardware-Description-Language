vlib work
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../../src/generic_adder_beh.vhd
vcom -93 -work work ../../src/generic_counter.vhd
vcom -93 -work work ../../src/seven_seg.vhd

vcom -93 -work work ../src/top_tb.vhd
vsim -novopt top_tb
do wave.do
run 500 ns
