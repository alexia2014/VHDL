
vlib work
vcom -93 -work work Banc.vhd
vcom -93 -work work Banc_tb.vhd

vsim Banc_tb(bench)

add wave *

run -all