onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /full_adder_single_bit_arc_tb/uut/a
add wave -noupdate /full_adder_single_bit_arc_tb/uut/b
add wave -noupdate /full_adder_single_bit_arc_tb/uut/cin
add wave -noupdate /full_adder_single_bit_arc_tb/uut/sum
add wave -noupdate /full_adder_single_bit_arc_tb/uut/cout
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1725 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 112
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {150 ns} {2635 ns}
