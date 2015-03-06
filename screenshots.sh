#!/bin/bash
#
# Captures regular screenshots and saves them to dropbox. 
# Useful when I leave my linux box doing number crunching
# over long periods.
#
# t = number of seconds in-between screenshots

t=7200 # 2 h

while true 
do
   gnome-screensaver-command -d # wakes up from screensaver
   sleep 15
   scrot -d $t '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f ~/Dropbox/Screenshots/ubuntu/';
   ls -1t ~/Dropbox/Screenshots/ubuntu/* | head -n1 # prints last file
done
