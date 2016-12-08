onerror {resume}
radix define States {
    "11'b001" "ADD" -color "orange",
    "11'b010" "SUBTRACT" -color "yellow",
    "11'b100" "IDLE" -color "blue",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /fsmd_tb/uut/clk
add wave -noupdate /fsmd_tb/uut/reset
add wave -noupdate /fsmd_tb/uut/button_press
add wave -noupdate -radix States /fsmd_tb/uut/state_reg
add wave -noupdate -radix States /fsmd_tb/uut/state_next
add wave -noupdate -color {Medium Violet Red} -radix unsigned /fsmd_tb/uut/a
add wave -noupdate -color {Medium Violet Red} -radix unsigned /fsmd_tb/uut/b
add wave -noupdate -radix unsigned /fsmd_tb/uut/add_sig
add wave -noupdate -radix unsigned /fsmd_tb/uut/sub_sig
add wave -noupdate -color Gold -radix unsigned /fsmd_tb/uut/result
add wave -noupdate /fsmd_tb/uut/idle_sig
add wave -noupdate /fsmd_tb/uut/result_next
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {589 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 307
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
WaveRestoreZoom {0 ns} {1050 ns}
