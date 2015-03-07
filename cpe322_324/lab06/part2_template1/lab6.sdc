# Constrain clock port clk with a 20-ns requirement
create_clock -period 20 -name CLOCK_50 [get_ports CLOCK_50]

## Specify a simple setup uncertainty of .3ns
## and a simple hold uncertainty of .1ns
set_clock_uncertainty 0.3ns -to CLOCK_50 -setup
set_clock_uncertainty 0.1ns -to CLOCK_50 -hold


