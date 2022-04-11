
vlib work
vcom -93 -work work Banc.vhd
vcom -93 -work work ALU.vhd
vcom -93 -work work TRAITEMENT.vhd
vcom -93 -work work TRAITEMENT_tb.vhd

vsim TRAITEMENT_tb(bench)

add wave *

run -all