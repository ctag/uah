set title "Efficiency vs Matrix Size on DMC. CC-gnu."
set xlabel "Efficiency E(n,p)"
set ylabel "Time (seconds)"
set autoscale
plot "dat/mm_gnu_all.dat" using 1:($2/(1*$2)) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/(2*$3)) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/(4*$4)) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/(6*$5)) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/(8*$6)) with linespoints
