vlib work
vcom -93 -work work ../../src/full_adder_single_bit_arc.vhd
vcom -93 -work work ../../src/my_and.vhd
vcom -93 -work work ../../src/my_or.vhd
vcom -93 -work work ../../src/my_xor.vhd
vcom -93 -work work ../src/full_adder_single_bit_arc_tb.vhd
vsim -novopt full_adder_single_bit_arc_tb
do wave.do
run 100 ns
