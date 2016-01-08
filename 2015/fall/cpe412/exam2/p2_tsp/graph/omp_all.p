set title "Data Size vs Runtime for p2-tsp-omp on DMC."
set xlabel "Data Size (cities)"
set ylabel "Time (seconds)"
set autoscale
plot "dat/time_omp.dat" using 1:2 with linespoints, \
"dat/time_omp.dat" using 1:3 with linespoints, \
"dat/time_omp.dat" using 1:4 with linespoints, \
"dat/time_omp.dat" using 1:5 with linespoints, \
"dat/time_omp.dat" using 1:6 with linespoints
