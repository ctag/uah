#!/bin/bash

FILE=$1

paste --delimiter='    ' $FILE sizes.txt > tmp.dat

mv tmp.dat $FILE

