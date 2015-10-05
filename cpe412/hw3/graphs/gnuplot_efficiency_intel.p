set title "Efficiency vs Matrix Size with MPI-ALL on DMC. CC-intel."
set xlabel "Efficiency E(n,p)"
set ylabel "Time (seconds)"
set autoscale
plot "intel/dat/mm_MPI_intel_all.dat" using 6:($1/(1*$1)) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/(2*$2)) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/(4*$3)) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/(6*$4)) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/(8*$5)) with linespoints
