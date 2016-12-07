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
add wave -noupdate /audio_processor_3000_tb/audio_processor/clk
add wave -noupdate /audio_processor_3000_tb/audio_processor/reset
add wave -noupdate /audio_processor_3000_tb/audio_processor/execute_btn
add wave -noupdate /audio_processor_3000_tb/audio_processor/sync
add wave -noupdate /audio_processor_3000_tb/audio_processor/led
add wave -noupdate /audio_processor_3000_tb/audio_processor/audio_out
add wave -noupdate -radix States /audio_processor_3000_tb/audio_processor/instruction
add wave -noupdate /audio_processor_3000_tb/audio_processor/repeat
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/pc
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_reg
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_play
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_play_repeat
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_stop
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_seek
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/data_address_pause
add wave -noupdate /audio_processor_3000_tb/audio_processor/edge
add wave -noupdate /audio_processor_3000_tb/audio_processor/state_reg
add wave -noupdate /audio_processor_3000_tb/audio_processor/state_next
add wave -noupdate /audio_processor_3000_tb/audio_processor/seek_address
add wave -noupdate -radix unsigned /audio_processor_3000_tb/audio_processor/opcode
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {2012 ns} 0}
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
WaveRestoreZoom {5 ns} {2105 ns}
