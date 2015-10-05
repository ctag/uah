#!/bin/bash

FILE=$1
COL_FILE=$2

paste --delimiter='\t' $FILE $COL_FILE > tmp.dat

mv tmp.dat $FILE

