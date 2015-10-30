#!/bin/bash

FROM=$1
TO=$2

cat $FROM | grep -Eo [[:digit:]\.]+ > $TO

