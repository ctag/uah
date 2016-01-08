#!/bin/bash

COUNT=2483

for index in {2..16}
do
    echo "Result of #${index} processes with list 2483:"
    mpirun -np $index $1 2483 | tail -n 3
done



