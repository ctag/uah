#!/bin/bash

for int in {0..14}
do
	echo $int
	printf "0: %.8d" $int | xxd -r -g0 >>tmp.dat
done
