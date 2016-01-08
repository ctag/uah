#!/bin/bash

FROM=$1
TO=$2

cat $FROM | grep -Eo [[:digit:]\.]+ > tmp.dat

paste --delimiter='\t' $TO tmp.dat > tmp2.dat

rm tmp.dat

mv tmp2.dat $TO

