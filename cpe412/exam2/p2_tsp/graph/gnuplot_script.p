set title "Data Size vs Runtime for p2-tsp-serial on DMC."
set xlabel "Data Size (cities)"
set ylabel "Time (seconds)"
set autoscale
plot "dat/time_serial.dat" using 1:2 with linespoints
