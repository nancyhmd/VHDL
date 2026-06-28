vlib work

vcom -93 ../src/alu.vhd
vcom -93 ../src/reg_file.vhd
vcom -93 ../src/mux2x1.vhd
vcom -93 ../src/sign_extender.vhd
vcom -93 ../src/data_memory.vhd
vcom -93 ../src/processing_unit.vhd
vcom -93 ../src/instruction_memory.vhd
vcom -93 ../src/instruction_fetch.vhd
vcom -93 ../src/instruction_decoder.vhd
vcom -93 ../src/psr_reg.vhd
vcom -93 ../src/solomono_processor.vhd
vcom -93 tb_solomono_processor.vhd


vsim tb_solomono_processor


add wave -divider "TOP LEVEL"
add wave -hex -label "Horloge"                  sim:/tb_solomono_processor/clk
add wave -label "Reset"                         sim:/tb_solomono_processor/rst
add wave -hex -label "Sortie Afficheur (STR)"   sim:/tb_solomono_processor/reg_aff_s

add wave -divider "FETCH & DECODER"
add wave -hex -label "Compteur PC"              sim:/tb_solomono_processor/UUT/FETCH_UNIT/PC_reg
add wave -hex -label "Instruction Hexa"         sim:/tb_solomono_processor/UUT/instruction
add wave -label "Instruction en Clair"          sim:/tb_solomono_processor/UUT/DECODER_UNIT/instr_courante

add wave -divider "BANC DE REGISTRES"
add wave -hex -label "Registre R1"              {sim:/tb_solomono_processor/UUT/PROCESSING_UNIT_INST/REG_FILE_INST/Banc(1)}
add wave -hex -label "Registre R2 (Accumulateur)" {sim:/tb_solomono_processor/UUT/PROCESSING_UNIT_INST/REG_FILE_INST/Banc(2)}

add wave -divider "REGISTRE ETAT (PSR)"
add wave -label "Drapeau Negatif (N)"           sim:/tb_solomono_processor/UUT/psr_out(31)
add wave -label "Drapeau Zero (Z)"              sim:/tb_solomono_processor/UUT/psr_out(30)


run 500 ns
wave zoom full