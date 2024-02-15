#!/bin/sh
#
# Converts all movie files in the current dir from the HEVC
# codec to the H.264 which is compatible with Raspberry Pi.
#

#for X in `ls -1 *.$1`
for X in `ls -1 *.mkv`
    do
    #TARGET=`basename $X .$1`
    TARGET=`basename $X .mkv`
    ffmpeg -i ${TARGET}.mkv -c:a copy -x265-params crf=25 ${TARGET}.mp4
    #eps2eps ${TARGET}.eps ../${TARGET}.eps
    done
