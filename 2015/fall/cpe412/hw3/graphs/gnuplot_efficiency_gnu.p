set title "Efficiency vs Matrix Size with MPI-ALL on DMC. CC-gnu."
set xlabel "Efficiency E(n,p)"
set ylabel "Time (seconds)"
set autoscale
plot "gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/(1*$1)) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/(2*$2)) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/(4*$3)) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/(6*$4)) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/(8*$5)) with linespoints
