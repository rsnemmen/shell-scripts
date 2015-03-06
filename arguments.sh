#!/bin/sh
#
# This script keeps on using shift until $# is down to zero, at which point the 
# list is empty.

while [ "$#" -gt "0" ]
do
  echo "\$1 is $1"
  shift
done    