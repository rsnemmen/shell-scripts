# Aplica o programa impose a todos os arquivos selecionados
# do diretório corrente, formata-os para impressão na
# psl205, e gera arquivos com extensão .imposed

# Uso: sh impose-batch.sh extensão (sem *.)

for X in $( ls -1 *.$1 )
    do
    impose $X    
    fixtd ${X}.imposed > ${X}.imposed~
    rm -f ${X}.imposed
    mv ${X}.imposed~ ${X}.imposed
    done
