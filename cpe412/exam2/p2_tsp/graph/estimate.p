# Time Estimate for Sequential Algorithm

set xrange [0:20]
set yrange [-100:8000]
set title "Sequential Algorithm Time Estimate"
set xlabel "# Cities"
set ylabel "Estimated Time (s)"
plot (6.59252546327E-11)*exp(2.17927659514*(x))
