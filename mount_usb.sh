#!/bin/sh
# Montar pendrive quando o Suse não reconhece automaticamente
# como root!
#
mount -t vfat /dev/sdb1 /mnt/removable -o noauto,user,exec,rw,sync