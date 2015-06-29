# Extração de legendas
# =====================

# Digamos que você tenha ripado o filme direitinho, porém as legendas
# foram extraídas erroneamente. Este script extrai apenas as legendas de
# um dvd, sem áudio ou vídeo, no formato vobsub.

mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas -sid 0 -vobsuboutindex 0 -chapter 8-14

