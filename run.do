vsim -voptargs="+acc" work.MC_tb

add wave -color "white" -radix decimal "sim:/p6502_tb/p6502_DUT/REG_FILE_INSTANCE/a_out"

add wave -color "red" -radix decimal "sim:/p6502_tb/p6502_DUT/REG_FILE_INSTANCE/x_out"

add wave -color "blue" -radix decimal "sim:/p6502_tb/p6502_DUT/REG_FILE_INSTANCE/y_out"


run -all
