#!/bin/bash

FILE=mm_MPI_${1}_${2}_time.dat
TMP=gnuplot_script.p

echo "set title \"Time vs Matrix Size with MPI-${2} on DMC. CC-${1}.\"" > $TMP
echo "set xlabel \"Square Matrix Size\"" >> $TMP
echo "set ylabel \"Time (seconds)\"" >> $TMP
echo "set autoscale" >> $TMP
echo "plot \"${FILE}\" using 2:1 with linespoints" >> $TMP

gnuplot -p $TMP

