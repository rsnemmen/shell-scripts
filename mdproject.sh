#!/bin/sh
# 
# Script to latex a project which includes markdown content
# written with iA Writer on OS X.
#

# copy markdown text from iCloud
cp ~/Documents/iawriter/JP.txt text.md

# convert md to latex
/Users/nemmen/work/software/shell/md2tex.sh text.md main