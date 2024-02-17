#!/bin/sh
#   Para conhecer as opções disponíveis, usar
#   mplayer -dvd 1 -dvd-device /dev/cdrom -v
#   e olhar a saída;

#   Nota sobre deinterlacing (retirado de
#   http://www.mplayerhq.hu/DOCS/HTML-single/en/MPlayer.html
#
#Consult mplayer -pphelp to see what's 
#available (grep for "deint"), and search the  MPlayer mailing lists #to find many discussions about the various filters.
#Also, deinterlacing should be done after cropping 
#and before scaling.

aid=128 # mencoder -aid #
nome_filme="advogado_do_diabo"
titulo=1 # mplayer -dvd #
#1cd= # 1 = sim, 0 = não
cap_metade=21 # O primeiro cd vai até este capítulo
cap_final=43 # O segundo inicia a partir do cap. especificado acima e termina neste
opcoes_adicionais="-vop pp=md,crop=720:360"
legendas="0 1 2" # opções de legendas (SID)

# Exporta as variáveis
export aid nome_filme titulo cap_metade cap_final opcoes_adicionais legendas

sh ./rip.sh
