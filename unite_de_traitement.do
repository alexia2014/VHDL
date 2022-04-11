
vlib work
vcom -93 -work work Banc.vhd
vcom -93 -work work ALU.vhd
vcom -93 -work work signe.vhd
vcom -93 -work work multiplexeur.vhd
vcom -93 -work work memoire.vhd
vcom -93 -work work unite_de_traitement.vhd
vcom -93 -work work unite_de_traitement_tb.vhd

vsim UNITE_TRAITEMENT_tb(bench)

add wave *

run -all