vlib work
vcom -93 -work work ../../src/top.vhd
vcom -93 -work work ../../src/synchronizer.vhd
vcom -93 -work work ../../src/seven_seg.vhd
vcom -93 -work work ../../src/rising_edge_synchronizer.vhd

vcom -93 -work work ../src/top_tb.vhd
vsim -novopt top_tb
do wave.do
run 12250 ns
