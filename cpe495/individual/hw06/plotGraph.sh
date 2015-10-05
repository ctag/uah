#!/bin/bash

FILE=$1
TMP=gnuplot_script.p

echo "set title \"HW6 Problem 4 consensus probability vs population.\"" > $TMP
echo "set xlabel \"Number of people\"" >> $TMP
echo "set ylabel \"Probability of agreement\"" >> $TMP
echo "set autoscale" >> $TMP
echo "plot \"${FILE}\" using 1:2 with linespoints, \"${FILE}\" using 1:3 with linespoints, \"${FILE}\" using 1:4 with linespoints, \"${FILE}\" using 1:5 with linespoints" >> $TMP

gnuplot -p $TMP

