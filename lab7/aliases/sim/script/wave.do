onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /aliases_tb/word
add wave -noupdate /aliases_tb/arg3
add wave -noupdate /aliases_tb/arg2
add wave -noupdate /aliases_tb/arg1
add wave -noupdate /aliases_tb/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 317
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
WaveRestoreZoom {0 ns} {11 ns}
