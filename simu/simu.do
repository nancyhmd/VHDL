# Création de la bibliothèque de travail
vlib work

# Compilation de l'ensemble des sources dans l'ordre de dépendance
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

# Lancement de la simulation
vsim tb_solomono_processor

# Ajout des signaux importants aux chronogrammes
add wave -position insertpoint sim:/tb_solomono_processor/clk
add wave -position insertpoint sim:/tb_solomono_processor/rst
add wave -position insertpoint sim:/tb_solomono_processor/UUT/instruction
add wave -position insertpoint sim:/tb_solomono_processor/UUT/FETCH_UNIT/PC_reg
add wave -position insertpoint sim:/tb_solomono_processor/UUT/DECODER_UNIT/instr_courante
add wave -position insertpoint sim:/tb_solomono_processor/reg_aff_s

# Lancement
run 400ns