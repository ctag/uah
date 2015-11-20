set title "Efficiency for p2-tsp-omp on DMC."
set xlabel "Data Size (cities)"
set ylabel "Efficiency (serial / (core * speed))"
set yrange [0:2]
plot "dat/time_omp.dat" using 1:($2/(1*$2)) with linespoints, \
"dat/time_omp.dat" using 1:($2/(2*$3)) with linespoints, \
"dat/time_omp.dat" using 1:($2/(4*$4)) with linespoints, \
"dat/time_omp.dat" using 1:($2/(8*$5)) with linespoints, \
"dat/time_omp.dat" using 1:($2/(12*$6)) with linespoints
