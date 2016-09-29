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
    -default default
}
quietly WaveActivateNextPane {} 0
add wave -noupdate /top_tb/uut/clk
add wave -noupdate /top_tb/uut/reset
add wave -noupdate -radix States -childformat {{/top_tb/uut/seven_seg_out(6) -radix States} {/top_tb/uut/seven_seg_out(5) -radix States} {/top_tb/uut/seven_seg_out(4) -radix States} {/top_tb/uut/seven_seg_out(3) -radix States} {/top_tb/uut/seven_seg_out(2) -radix States} {/top_tb/uut/seven_seg_out(1) -radix States} {/top_tb/uut/seven_seg_out(0) -radix States}} -expand -subitemconfig {/top_tb/uut/seven_seg_out(6) {-radix States} /top_tb/uut/seven_seg_out(5) {-radix States} /top_tb/uut/seven_seg_out(4) {-radix States} /top_tb/uut/seven_seg_out(3) {-radix States} /top_tb/uut/seven_seg_out(2) {-radix States} /top_tb/uut/seven_seg_out(1) {-radix States} /top_tb/uut/seven_seg_out(0) {-radix States}} /top_tb/uut/seven_seg_out
add wave -noupdate /top_tb/uut/clk
add wave -noupdate /top_tb/uut/reset
add wave -noupdate /top_tb/uut/seven_seg_out
add wave -noupdate /top_tb/uut/sum_sig
add wave -noupdate /top_tb/uut/enable_sig
add wave -noupdate /top_tb/uut/adder_sig
add wave -noupdate /top_tb/uut/adder/a
add wave -noupdate /top_tb/uut/adder/b
add wave -noupdate /top_tb/uut/adder/cin
add wave -noupdate /top_tb/uut/adder/sum
add wave -noupdate /top_tb/uut/adder/cout
add wave -noupdate /top_tb/uut/adder/sum_temp
add wave -noupdate /top_tb/uut/adder/cin_guard
add wave -noupdate /top_tb/uut/counter/clk
add wave -noupdate /top_tb/uut/counter/reset
add wave -noupdate /top_tb/uut/counter/output
add wave -noupdate /top_tb/uut/counter/count_sig
add wave -noupdate /top_tb/uut/convert_to_ssd/bcd
add wave -noupdate /top_tb/uut/convert_to_ssd/seven_seg_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ns} 0}
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
WaveRestoreZoom {0 ns} {585 ns}
