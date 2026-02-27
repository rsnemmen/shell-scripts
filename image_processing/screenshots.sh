#!/bin/bash
#
# Captures regular screenshots and saves them to dropbox. 
# Useful when I leave my linux box doing number crunching
# over long periods.
#
# t = number of seconds in-between screenshots

t=14400 # 4 h

while true 
do
   sleep $t # t seconds between each screenshot
   gnome-screensaver-command -d # wakes up from screensaver
   sleep 10 # processing time
   scrot '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f ~/Dropbox/Screenshots/ubuntu/' # screenshot
   ls -1t ~/Dropbox/Screenshots/ubuntu/* | head -n1 # prints last file
done
