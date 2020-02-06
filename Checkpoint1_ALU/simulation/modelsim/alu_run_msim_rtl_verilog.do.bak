transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_add.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/mux8to1.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_and.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_or.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_subtract.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_sll.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_sra.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/mux2to1.v}

vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/project\ 1 {C:/Users/11789/Desktop/ECE 550/project 1/alu_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  alu_tb

add wave *
view structure
view signals
run -all
