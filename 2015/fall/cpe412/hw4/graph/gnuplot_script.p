set title "Runtime vs Data Size with pthreads on DMC. CC-gnu."
set xlabel "Data Size (elements)"
set ylabel "Time (seconds)"
set autoscale
plot "mm_serial_gnu_1.dat" using 2:1 with linespoints, \
"mm_pthread_gnu_2.dat" using 2:1 with linespoints, \
"mm_pthread_gnu_4.dat" using 2:1 with linespoints, \
"mm_pthread_gnu_6.dat" using 2:1 with linespoints, \
"mm_pthread_gnu_8.dat" using 2:1 with linespoints, \
