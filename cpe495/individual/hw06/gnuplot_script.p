set title "HW6 Problem 4 consensus probability vs population."
set xlabel "Number of people"
set ylabel "Probability of agreement"
set autoscale
plot "p4.dat" using 1:2 with linespoints, "p4.dat" using 1:3 with linespoints, "p4.dat" using 1:4 with linespoints, "p4.dat" using 1:5 with linespoints
