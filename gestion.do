
vlib work
vcom -93 -work work signe.vhd
vcom -93 -work work instruction_memory.vhd
vcom -93 -work work gestion.vhd
vcom -93 -work work gestion_tb.vhd

vsim GESTION_tb(bench)

add wave *

run -all