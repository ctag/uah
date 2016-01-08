set title "Speedup for p2-tsp-omp on DMC."
set xlabel "Data Size (cities)"
set ylabel "Speedup (time_1 / time_core)"
set autoscale
plot "dat/time_omp.dat" using 1:($2/$2) with linespoints, \
"dat/time_omp.dat" using 1:($2/$3) with linespoints, \
"dat/time_omp.dat" using 1:($2/$4) with linespoints, \
"dat/time_omp.dat" using 1:($2/$5) with linespoints, \
"dat/time_omp.dat" using 1:($2/$6) with linespoints
