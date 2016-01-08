set title "Speedup vs Matrix Size with MPI-ALL on DMC. CC-intel."
set ylabel "Speedup S(n,p)"
set xlabel "Time (seconds)"
set autoscale
plot "intel/dat/mm_MPI_intel_all.dat" using 6:($1/$1) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/$2) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/$3) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/$4) with linespoints, \
"intel/dat/mm_MPI_intel_all.dat" using 6:($1/$5) with linespoints
