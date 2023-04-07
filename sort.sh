#!/bin/sh
#
# Script que chama o Grace, utilizando-o para ordenar
# um arquivo de dados.
#
# Sintaxe: sumData.sh dados out
# onde dados é o arquivo de dados,
# e out é o nome do arquivo de saída a ser gerado.
#
# sort.gr é o script que opera o Grace.

# Antes de fazer a ordenação, elimina linhas em branco do arquivo,
# fazem o grace se atrapalhar!!
#awk "\$0 != \"\"" temp.temp.dat > temp.temp.dat~

sed "s/OUT/\"${2}\"/g" sort.gr > temp.gr
grace $1 -batch temp.gr -nosafe
rm -f temp.gr

