vlib work
vcom -93 -work work ../../src/fsmd.vhd
vcom -93 -work work ../src/fsmd_tb.vhd
vsim -novopt fsmd_tb
do wave.do
run 1 us
