transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/csb0019/Documents/uah/cpe322_324/hw_sim_01/behavioral {C:/Users/csb0019/Documents/uah/cpe322_324/hw_sim_01/behavioral/eight_bit_sub_add.v}

