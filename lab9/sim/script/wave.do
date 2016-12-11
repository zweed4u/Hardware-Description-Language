onerror {resume}
radix define States {
    "8'b000?????" "Play" -color "green",
    "8'b001?????" "Play Repeat" -color "purple",
    "8'b01??????" "Pause" -color "orange",
    "8'b10??????" "Seek" -color "blue",
    "8'b11??????" "Stop" -color "red",
    -default hexadecimal
    -defaultcolor white
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /audio_processor_3000_tb/clk
add wave -noupdate /audio_processor_3000_tb/reset
add wave -noupdate /audio_processor_3000_tb/sync
add wave -noupdate /audio_processor_3000_tb/execute_btn
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6417 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 202
configure wave -valuecolwidth 48
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
configure wave -timelineunits us
update
WaveRestoreZoom {0 ns} {21175 ns}
