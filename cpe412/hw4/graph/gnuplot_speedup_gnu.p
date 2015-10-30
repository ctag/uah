set title "Speedup vs Matrix Size on DMC. CC-gnu."
set xlabel "Speedup S(n,p)"
set ylabel "Time (seconds)"
set autoscale
plot "dat/mm_gnu_all.dat" using 1:($2/$2) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/$3) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/$4) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/$5) with linespoints, \
"dat/mm_gnu_all.dat" using 1:($2/$6) with linespoints, \
