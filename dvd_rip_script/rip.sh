# *********************************
# Script para ripagem com mencoder
# v2.0 (24/05/2004)
# Autor: rns
# *********************************

# CD 01
# ====================================================

# Muda para o diretório correspondente
if [ -d "cd01" ] # Verifica se o diretório existe e o cria
then
    cd cd01
else
    mkdir cd01
    cd cd01
fi

# Apaga arquivos anteriores que podem causar conflitos
rm -f frameno.avi *.log

# Primeira passada (áudio)
# =================
mencoder -dvd $titulo -dvd-device /dev/cdrom -o frameno.avi -ovc frameno -oac mp3lame -lameopts abr:br=140 -aid $aid -chapter 1-$cap_metade \
| awk '{print} \
(/Recommended/ && /bitrate/) || (/Video|Audio/ && /stream/)  {print $0 >> "1stpass-cd01.txt"}'

# Lê o arquivo 1stpass-cd01.txt e extrai o valor da bitrate para um cd 700 MB.
# Geralmente este valor corresponde ao recomendado pelo mencoder para um
# cd de 800MB.
bitrate=`awk '$5 ~ /800MB/ {print $7}' 1stpass-cd01.txt`

# Segunda passada (vídeo 01)
# ================
mencoder -dvd $titulo -dvd-device /dev/cdrom -nosound -oac copy -o /dev/null -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=1:vbitrate=$bitrate $opcoes_adicionais -chapter 1-$cap_metade

# Terceira passada (vídeo 02)
# =================
mencoder -dvd $titulo -dvd-device /dev/cdrom -oac copy -o ${nome_filme}-parte01.divx4.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=2:vbitrate=$bitrate $opcoes_adicionais -chapter 1-$cap_metade

# Extração das legendas
# ======================

# Determina o número de legendas a serem extraídas
contf=`echo "$legendas" | awk '{print NF}'`

# Extrai cada coluna da string legendas e passa para a variável sid
for ((  cont = 1 ;  cont <= contf;  cont++  ))
do
sid=`echo "$legendas" | awk '{print $i}' i=$cont`
mencoder -dvd $titulo -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout ${nome_filme}-parte01.divx4 -sid $sid -vobsuboutindex $sid -chapter 1-$cap_metade
done

# CD 02
# ============================================================

# Muda para o diretório correspondente
if [ -d "../cd02" ] # Verifica se o diretório existe e o cria
then
    cd ../cd02
else
    mkdir ../cd02
    cd ../cd02
fi

# Apaga arquivos anteriores que podem causar conflitos
rm -f frameno.avi *.log

# Capítulo a partir do qual inicia-se a ripagem do segundo cd
cap_cd02=`expr $cap_metade + 1`

# Primeira passada (áudio)
# =================
mencoder -dvd $titulo -dvd-device /dev/cdrom -o frameno.avi -ovc frameno -oac mp3lame -lameopts abr:br=140 -aid $aid -chapter $cap_cd02-$cap_final \
| awk '{print} \
(/Recommended/ && /bitrate/) || (/Video|Audio/ && /stream/)  {print $0 >> "1stpass-cd02.txt"}'

# Lê o arquivo 1stpass-cd01.txt e extrai o valor da bitrate para um cd 700 MB.
# Geralmente este valor corresponde ao recomendado pelo mencoder para um
# cd de 800MB.
bitrate=`awk '$5 ~ /800MB/ {print $7}' 1stpass-cd02.txt`

# Segunda passada (vídeo 01)
# ================
mencoder -dvd $titulo -dvd-device /dev/cdrom -nosound -oac copy -o /dev/null -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=1:vbitrate=$bitrate $opcoes_adicionais -chapter $cap_cd02-$cap_final

# Terceira passada (vídeo 02)
# =================
mencoder -dvd $titulo -dvd-device /dev/cdrom -oac copy -o ${nome_filme}-parte02.divx4.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=2:vbitrate=$bitrate $opcoes_adicionais -chapter $cap_cd02-$cap_final

# Extração das legendas
# ======================

# Determina o número de legendas a serem extraídas
contf=`echo "$legendas" | awk '{print NF}'`

# Extrai cada coluna da string legendas e passa para a variável sid
for ((  cont = 1 ;  cont <= contf;  cont++  ))
do
sid=`echo "$legendas" | awk '{print $i}' i=$cont`
mencoder -dvd $titulo -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout ${nome_filme}-parte02.divx4 -sid $sid -vobsuboutindex $sid -chapter $cap_cd02-$cap_final
done
