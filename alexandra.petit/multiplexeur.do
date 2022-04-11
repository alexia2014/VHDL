
vlib work
vcom -93 -work work multiplexeur.vhd
vcom -93 -work work multiplexeur_tb.vhd

vsim multiplexeur_tb(bench)

add wave *

run -all