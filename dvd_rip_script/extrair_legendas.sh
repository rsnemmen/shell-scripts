# Extra��o de legendas
# =====================

# Digamos que voc� tenha ripado o filme direitinho, por�m as legendas
# foram extra�das erroneamente. Este script extrai apenas as legendas de
# um dvd, sem �udio ou v�deo, no formato vobsub.

mencoder -dvd 1 -dvd-device /dev/cdrom -nosound -oac copy -ovc copy -o /dev/null -vobsubout legendas -sid 0 -vobsuboutindex 0 -chapter 8-14

