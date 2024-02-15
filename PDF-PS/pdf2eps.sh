# Converts all PDF files in the current directory to EPS files, with
# the quality appropriate for papers (e.g. ApJ).
#
# Usage: 
# $   sh pdf2eps.sh

for X in $( ls -1 *.pdf )
do
TARGET=`basename $X .pdf`
pdf2ps $X ${TARGET}.eps
done
