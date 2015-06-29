#!/bin/sh
# 
# Creates movie file based on sequential images.
#
# Usage: mencoder.sh fps output.avi
# 	e.g. mencoder.sh 5 movie.avi

ls plot.* | sort -n -t . -k 2 > list.txt
mencoder "mf://@list.txt" -mf fps=$1 -o $2 -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=800
