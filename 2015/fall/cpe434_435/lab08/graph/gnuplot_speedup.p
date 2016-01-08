set title "Serial vs Threads Time for lab8."
set xlabel "Interval Count"
set ylabel "Time (seconds)"
set autoscale
plot "serial.dat" using 1:2 with linespoints, \
"thread2.dat" using 1:2 with linespoints, \
"thread4.dat" using 1:2 with linespoints, \
"thread6.dat" using 1:2 with linespoints
