transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/regfile.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/decoder5to32.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/tristate_buffer.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/dffe_ref.v}
vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/reg32.v}

vlog -vlog01compat -work work +incdir+C:/Users/11789/Desktop/ECE\ 550/Checkpoint\ 2\ Regfile {C:/Users/11789/Desktop/ECE 550/Checkpoint 2 Regfile/regfile_tb.v}

vsim -t 1ps -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver -L altera_lnsim_ver -L cycloneive_ver -L rtl_work -L work -voptargs="+acc"  regfile_tb

add wave *
view structure
view signals
run -all
