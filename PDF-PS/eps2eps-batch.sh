# Aplica o programa eps2eps a todos os arquivos eps do diretorio corrente,
# criando novos arquivos com extensao ,eps~.

for X in `ls -1 *.eps`
    do
    TARGET=`basename $X .eps`
    eps2eps ${TARGET}.eps ../${TARGET}.eps
    done
