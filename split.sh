# Script para dividir um divx em duas partes.
#
# O segredo � obter o tempo total de dura��o do filme divx, depois estimar qual
# o tempo correspondente ao tamanho de cada cd.

# Primeiro grava at� o tempo endpos
mencoder -ovc copy -oac copy -endpos 01:16:00 -o harry_potter_pedra_filosofal-parte01.divx.avi harry_potter_pedra_filosofal.divx.avi

# Depois continua a partir do tempo ss
mencoder -ovc copy -oac copy -ss 01:16:00 -o  harry_potter_pedra_filosofal-parte02.divx.avi harry_potter_pedra_filosofal.divx.avi
