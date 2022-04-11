
vlib work
vcom -93 -work work memoire.vhd
vcom -93 -work work memoire_tb.vhd

vsim memoire_tb(bench)

add wave *

run -all