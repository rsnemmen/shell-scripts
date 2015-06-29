# Minhas opções
# ==============

# Algumas dicas:
# - Não esquecer de incluir todas as opções de legendas desejadas, uma em cada
#   passada. Para conhecer as opções disponíveis, usar
#   mplayer -dvd 1 -dvd-device /dev/cdrom -v -vo x11
#   e olhar a saída;
# - Conferir com o mplayer se o áudio está na língua desejada (opção -aid # do
#   mencoder);
# - Anotar a saída do video bitrate da primeira passada, pra saber o tamanho
#   que o filme vai requerer. Geralmente, quando o filme tem mais de 1h30min,
#   ele necessita de dois cds pra ficar com uma resolução decente. Pra ter
#   certeza, basta rodar a primeira passada, e ver a "recommended video
#   bitrate for 700MB CD"; se for menor que 900, o filme deve ser ripado em
#   dois cds;
# - Caso queiramos dois cds, devemos repetir as 3 passadas para o segundo cd.

# Video bitrates recomendadas
# ============================

# CD 01:Recommended video bitrate for 650MB CD: 978
#Recommended video bitrate for 700MB CD: 1065
#Recommended video bitrate for 800MB CD: 1239
# CD 02:Recommended video bitrate for 650MB CD: 1273
#Recommended video bitrate for 700MB CD: 1382
#Recommended video bitrate for 800MB CD: 1602


# CD 01

# Muda para o diretório correspondente
cd cd01

# Apaga arquivos anteriores que podem causar conflitos
#rm -f frameno.avi *.log

# Primeira passada (áudio)
#mencoder -dvd 1 -dvd-device /dev/cdrom -o frameno.avi -ovc frameno -oac mp3lame -lameopts abr:br=140 -aid 128 -chapter 1-8

# Segunda passada (vídeo 01)
#mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -o /dev/null -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=1:vbitrate=1239 -vop crop=720:280 -chapter 1-8

# Terceira passada (vídeo 02)
#mencoder -dvd 1 -dvd-device /dev/cdrom -oac copy -o 4_de_julho.divx4.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=2:vbitrate=1239 -vop crop=720:280 -chapter 1-8

# Extração das legendas
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte01 -sid 0 -vobsuboutindex 0 -chapter 1-8
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte01 -sid 1 -vobsuboutindex 1 -chapter 1-8
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte01 -sid 2 -vobsuboutindex 2 -chapter 1-8

# CD 02

# Muda para o diretório correspondente
cd ../cd02

# Apaga arquivos anteriores que podem causar conflitos
#rm -f frameno.avi *.log

# Primeira passada (áudio)
#mencoder -dvd 1 -dvd-device /dev/cdrom -o frameno.avi -ovc frameno -oac mp3lame -lameopts abr:br=150 -aid 128 -chapter 9-17

# Segunda passada (vídeo 01)
#mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -o /dev/null -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=1:vbitrate=1602 -vop crop=720:280 -chapter 9-17

# Terceira passada (vídeo 02)
#mencoder -dvd 1 -dvd-device /dev/cdrom -oac copy -o 4_de_julho-parte02.divx4.avi -ovc lavc -lavcopts vcodec=mpeg4:vhq:vpass=2:vbitrate=1602 -vop crop=720:280 -chapter 9-17

# Extração das legendas
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte02 -sid 0 -vobsuboutindex 0 -chapter 9-17
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte02 -sid 1 -vobsuboutindex 1 -chapter 9-17
mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas-parte02 -sid 2 -vobsuboutindex 2 -chapter 9-17

