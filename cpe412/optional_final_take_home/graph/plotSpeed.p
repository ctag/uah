set title "Time vs Data Size for Jetson Node-Node Communication."
set xlabel "Data Size (bytes)"
set ylabel "Averaged Time (seconds)"
set autoscale
plot "speedTest.dat" using 1:2 with linespoints
