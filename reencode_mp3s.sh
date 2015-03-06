#!/bin/sh
#
# Takes a bunch of mp3 files and reencode them with different bitrates
# and sampling frequencies.
# Requirements: mpg123, sox, lame
for file
do
  TARGET=`basename $file .mp3`
  mpg123 -sv -r 44100 $file | sox -t raw -r 44100 -s -w -c 2 - ${TARGET}.wav
  lame -h -b 56 --resample 44.1 ${TARGET}.wav ${TARGET}-new.mp3
  rm -f ${TARGET}.wav
done