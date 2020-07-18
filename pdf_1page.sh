#!/bin/sh
# Extract first two pages of each PDF and put in another folder

for X in $( ls -1 *.pdf )
do
pdftk $X cat 1 output 1p/$X
done
