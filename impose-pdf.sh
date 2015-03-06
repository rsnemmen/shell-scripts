#!/bin/sh

# This program takes a bunch of pdf files, convert them to ps,
# runs impose (2-up) and then fix the files so that they
# can be printed in a non-duplex printer.

while [ "$#" -gt "0" ]
do
    TARGET=`basename $1 .pdf`
    pdf2ps ${TARGET}.pdf ${TARGET}.ps
    impose ${TARGET}.ps    
    rm -f ${TARGET}.ps
    fixtd ${TARGET}.ps.imposed > ${TARGET}.ps.imposed~
    rm -f ${TARGET}.ps.imposed
    mv ${TARGET}.ps.imposed~ ${TARGET}.ps.imposed
    shift
done    
