transcript on
if {[file exists rtl_work]} {
	vdel -lib rtl_work -all
}
vlib rtl_work
vmap work rtl_work

vlog -vlog01compat -work work +incdir+C:/Users/csb0019/Documents/uah/cpe322_324/lab03/structural {C:/Users/csb0019/Documents/uah/cpe322_324/lab03/structural/eight_bit_sub_add.v}

