vlib work
vcom -93 -work work ../src/aliases_tb.vhd
vsim -novopt aliases_tb
do wave.do
run 10 ns
