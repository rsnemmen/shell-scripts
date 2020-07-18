#!/bin/sh
# Prints PDF files

for file
do
pdftops $file - | lpr -Ppsn101
done

