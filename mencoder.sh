#!/bin/sh
# 
# Creates movie file based on sequential images.
#
# Usage: mencoder.sh fps output.avi
# 	e.g. mencoder.sh 5 movie.avi

ls plot.* | sort -n -t . -k 2 > list.txt
mencoder "mf://@list.txt" -mf fps=$1 -o $2 -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=800

#mencoder dvd://1 -o /dev/null -ss 32 -ovc x264 -x264encopts pass=1:turbo:bitrate=900:bframes=1:me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300 -vf crop=720:352:0:62,scale=-10:-1,harddup -oac faac -faacopts br=192:mpeg=4:object=2 -channels 2 -srate 48000 -ofps 24000/1001

#mencoder dvd://1 -o narnia.avi -ss 32 -ovc x264 -x264encopts pass=2:turbo:bitrate=900:frameref=5:bframes=1:me=umh:partitions=all:trellis=1:qp_step=4:qcomp=0.7:direct_pred=auto:keyint=300 -vf crop=720:352:0:62,scale=-10:-1,harddup -oac faac -faacopts br=192:mpeg=4:object=2 -channels 2 -srate 48000 -ofps 24000/1001

