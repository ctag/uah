# Constrain clock port clk with a 20-ns requirement

create_clock -period 20 -name CLOCK_50 [get_ports CLOCK_50]

derive_pll_clocks

# Constrain the input I/O path

set_input_delay -clock CLOCK_50 -max 9 [all_inputs]

set_input_delay -clock CLOCK_50 -min 0 [all_inputs]

