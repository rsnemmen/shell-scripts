#!/bin/bash
#
# Unpacks all 7z files in the current directory
#

for file in *.7z
do
	7z x "$file" 
done
