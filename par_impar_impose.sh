#!/bin/sh

# Roda impose num artigo, separa as páginas pares e ímpares 
# para impressão numa impressora não-duplex.

for X in `ls -1 *.pdf`
do
TARGET=`basename $X .pdf`
pdf2ps ${TARGET}.pdf ${TARGET}.ps
psselect -o ${TARGET}.ps ${TARGET}.ps.impar
psselect -e ${TARGET}.ps ${TARGET}.ps.par
done
