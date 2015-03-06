# Converte todas as figuras do diretório corrente para
# o formato eps, usando o SAM2P.

# Uso: sh sam2p-batch.sh <formato>
# Exemplo: sh sam2p-batch.sh jpg   --> converte todas imagens jpg para eps

for X in $( ls -1 *.$1 )
do
TARGET=`basename $X .$1`
sam2p $X ${TARGET}.eps
done
