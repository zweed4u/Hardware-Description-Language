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
    "7'b1111111" "" -color "red",
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/uut/clk
add wave -noupdate /top_tb/uut/reset
add wave -noupdate -radix binary /top_tb/uut/synced_a
add wave -noupdate -radix binary /top_tb/uut/synced_b
add wave -noupdate /top_tb/uut/synced_add
add wave -noupdate /top_tb/uut/synced_sub
add wave -noupdate /top_tb/uut/synced_sel
add wave -noupdate -radix binary -radixshowbase 0 /top_tb/uut/seven_seg_a
add wave -noupdate -radix binary -radixshowbase 0 /top_tb/uut/seven_seg_b
add wave -noupdate /top_tb/uut/add_sub_out
add wave -noupdate -radix binary -radixshowbase 0 /top_tb/uut/seven_seg_res
add wave -noupdate /top_tb/a
add wave -noupdate /top_tb/b
add wave -noupdate /top_tb/add
add wave -noupdate /top_tb/sub
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {880 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 177
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
