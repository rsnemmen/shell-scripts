#!/bin/sh
# 
# Creates movie file based on sequential images.
#
# Usage: mencoder.sh <fps> <output file basename>
# 	e.g. mencoder.sh 5 movie

bitrate=900


# check if there were command-line arguments
if [ $# -eq 0 ]; then
    echo "Usage: "
    echo "  mencoder.sh <fps> <output file basename> "
    exit 1
fi


# creates sequential list of files that will be rendered
ls -v  fig*.png  > list.txt

mencoder "mf://@list.txt" -mf fps=$1 -o $2.avi -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=$bitrate

#rm list.txt

# Quicktime compatible movie (OS X)
# ===========================
# http://www.mplayerhq.hu/DOCS/HTML/en/menc-feat-quicktime-7.html

# pass 1
#mencoder "mf://@list.txt" -ovc x264 -x264encopts pass=1:turbo:bitrate=$bitrate:bframes=1:me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300:threads=auto -oac faac -faacopts br=192:mpeg=4:object=2 -channels 2 -srate 48000 -mf fps=$1 

# pass 2
#mencoder "mf://@list.txt" -o movie.avi -ovc x264 -x264encopts pass=2:turbo:bitrate=$bitrate:frameref=5:bframes=1:me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300:threads=auto -oac faac -faacopts br=192:mpeg=4:object=2 -channels 2 -srate 48000 -mf fps=$1 

#ffmpeg -i $2.avi -acodec libmp3lame -ab 192 movie.mov
