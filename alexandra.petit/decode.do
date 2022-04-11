
vlib work
vcom -93 -work work signe.vhd
vcom -93 -work work PSR.vhd
vcom -93 -work work decode.vhd
vcom -93 -work work decode_tb.vhd

vsim decode_tb(bench)

add wave *

run -all