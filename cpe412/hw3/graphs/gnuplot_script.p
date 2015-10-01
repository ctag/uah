set title "Time vs Matrix Size with MPI-8 on DMC. CC-intel."
set xlabel "Square Matrix Size"
set ylabel "Time (seconds)"
set autoscale
plot "mm_MPI_intel_8_time.dat" using 2:1 with linespoints
