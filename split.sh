# Script para dividir um divx em duas partes.
#
# O segredo é obter o tempo total de duração do filme divx, depois estimar qual
# o tempo correspondente ao tamanho de cada cd.

# Primeiro grava até o tempo endpos
mencoder -ovc copy -oac copy -endpos 01:16:00 -o harry_potter_pedra_filosofal-parte01.divx.avi harry_potter_pedra_filosofal.divx.avi

# Depois continua a partir do tempo ss
mencoder -ovc copy -oac copy -ss 01:16:00 -o  harry_potter_pedra_filosofal-parte02.divx.avi harry_potter_pedra_filosofal.divx.avi
