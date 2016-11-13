onerror {resume}
radix define States {
    "7'b1000000" "0" -color "red",
    "7'b1111001" "1" -color "red",
    "7'b0100100" "2" -color "red",
    "7'b0110000" "3" -color "red",
    "7'b0011001" "4" -color "red",
    "7'b0010010" "5" -color "red",
    "7'b0000010" "6" -color "red",
    "7'b1111000" "7" -color "red",
    "7'b0000000" "8" -color "red",
    "7'b0011000" "9" -color "red",
    "7'b0001000" "a" -color "red",
    "7'b0000011" "b" -color "red",
    "7'b1000110" "c" -color "red",
    "7'b0100001" "d" -color "red",
    "7'b0000110" "e" -color "red",
    "7'b0001110" "f" -color "red",
    "7'b1111111" "-color",
    "red" "-default",
    "default" "-default",
    "default" "",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/uut/switch
add wave -noupdate -radix binary /top_tb/uut/op
add wave -noupdate /top_tb/uut/clk
add wave -noupdate /top_tb/uut/reset_n
add wave -noupdate /top_tb/uut/mr
add wave -noupdate /top_tb/uut/ms
add wave -noupdate /top_tb/uut/execute
add wave -noupdate -radix States /top_tb/uut/seven_seg_hun
add wave -noupdate -radix States /top_tb/uut/seven_seg_ten
add wave -noupdate -radix States /top_tb/uut/seven_seg_one
add wave -noupdate -radix binary /top_tb/uut/led
add wave -noupdate -radix binary /top_tb/uut/stateReg
add wave -noupdate -radix binary /top_tb/uut/stateNext
add wave -noupdate -radix binary /top_tb/uut/synced_sw
add wave -noupdate -radix binary /top_tb/uut/synced_op
add wave -noupdate /top_tb/uut/synced_mr
add wave -noupdate /top_tb/uut/synced_ms
add wave -noupdate /top_tb/uut/synced_execute
add wave -noupdate /top_tb/uut/save
add wave -noupdate /top_tb/uut/result_sig
add wave -noupdate /top_tb/uut/to_mem
add wave -noupdate /top_tb/uut/preDD
add wave -noupdate /top_tb/uut/ones
add wave -noupdate /top_tb/uut/tens
add wave -noupdate /top_tb/uut/hundreds
add wave -noupdate /top_tb/uut/state_reg_output
add wave -noupdate /top_tb/uut/output_logic_we
add wave -noupdate /top_tb/uut/output_logic_addr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {6514 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
configure wave -valuecolwidth 135
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {7875 ns}
