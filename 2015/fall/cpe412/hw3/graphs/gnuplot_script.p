set title "Speedup vs Matrix Size with MPI-ALL on DMC. CC-gnu."
set xlabel "Speedup S(n,p)"
set ylabel "Time (seconds)"
set autoscale
plot "gnu/dat/mm_MPI_gnu_all.dat" using 6:($1/$1) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($2/$1) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($3/$1) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($4/$1) with linespoints, \
"gnu/dat/mm_MPI_gnu_all.dat" using 6:($5/$1) with linespoints, \
