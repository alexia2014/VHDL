
vlib work
vcom -93 -work work ALU.vhd
vcom -93 -work work banc.vhd
vcom -93 -work work decode.vhd
vcom -93 -work work gestion.vhd
vcom -93 -work work memoire.vhd
vcom -93 -work work multiplexeur.vhd
vcom -93 -work work PSR.vhd
vcom -93 -work work signe.vhd
vcom -93 -work work traitement.vhd
vcom -93 -work work unite_de_traitement.vhd
vcom -93 -work work processeur.vhd
vcom -93 -work work processeur_tb.vhd

vsim PROCESSEUR_tb(bench)

add wave *

run -all