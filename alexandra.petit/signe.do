
vlib work
vcom -93 -work work signe.vhd
vcom -93 -work work signe_tb.vhd

vsim signe_tb(bench)

add wave *

run -all