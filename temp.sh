indice="http://www.diplo.com.br/aberto/0408/indice.htm"
art=960
num=16
mes="Agosto"
saida="agosto.ps"

comando="htmldoc " $indice " "
i=$art
fim=expr $num + $art # contador do artigo final
fim=expr $fim - 1
while [ $i -le $fim ]; do
    comando=$comando "http://www.diplo.com.br/aberto/materia.php?id=" $i " "
    i=$((i + 1))
done

echo $comando
