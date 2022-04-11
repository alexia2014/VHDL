
vlib work
vcom -93 -work work ALU.vhd
vcom -93 -work work ALU_tb.vhd

vsim ALU_tb(bench1)

add wave *

run -all