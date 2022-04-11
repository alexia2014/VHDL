
vlib work
vcom -93 -work work PSR.vhd
vcom -93 -work work PSR_tb.vhd

vsim PSR_tb(bench)

add wave *

run -all