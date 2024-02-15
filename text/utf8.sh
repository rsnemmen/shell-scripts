#!/bin/sh
#
# Converts a set of files from iso-8859-1 to uft-8. Check
# http://mediakey.dk/~cc/howto-convert-text-file-from-utf-8-to-iso-8859-1-encoding/

for file
do
  echo "Processing file" $file 
  iconv --verbose --from-code=ISO-8859-1 --to-code=UTF-8 $file > tmp.txt
  mv -f tmp.txt $file
done
