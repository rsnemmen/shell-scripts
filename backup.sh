#!/bin/sh
#
# Faz backup dos arquivos relevantes do laptop. 

cd ~

# Arquivos a serem copiados
# Tenho que usar as vari�eis adicionais file01 etc abaixo para
# fazer com que o shell entenda os espa�s nos nomes dos
# diret�ios.
files="/media/sda2/home"
#file01="win/mydocs/My Pictures"
#file02="/mnt/win_d/home"

# Requisito: devo estar logado na rede do IF.
#rsync -cvaL --progress -e ssh $files "$file01" "$file02" "$file03" rns@pcastro20:./downloads/backup

# Usando rsync quando estou em casa.
#rsync -cvaL --progress $files "$file01" "$file02" win/desktop/H/shared/backup/laptop

# Usando rsync para gravar os arquivos no meu hd externo de 120 GB.
echo "Certifique-se de que montou /media/HD120GB com ntfs-3g (root)!"
echo " 1. Plugue o dispositivo, verifique se ele foi montado corretamente com ntfs-3g"
#echo " 1. Plugue o dispositivo, desmonte-o se ele for montado automaticante"
#echo " 2. Rode $ mount -t ntfs-3g /dev/sdb1 /media/HD120GB/"
#echo "Prosseguir? (ENTER - sim ou CTRL-C - n�)"
read REPLY
echo " 2. Rode o truecrypt com o comando: "
echo "$ truecrypt --filesystem ntfs-3g /media/HD120GB/backup_laptop.tc /mnt/tc"
echo "Truecrypt funcionou corretamente?"
read REPLY
rsync -cvaL --delete --progress $files /mnt/tc
#echo "Desmontar volume protegido?"
#read
#truecrypt -d

# Backup quando estou em casa.
# Tenho um hd com bastante espaco montado no windows
# e compartilhado, e tenho acesso a este hd no linux
# usando samba. O comando abaixo 
#tar -cvzf - $files "$file01" "$file02" "$file03" | split -b 1990m - win/desktop/H/shared/backup/backup_laptop_tgz

# Qual o tamanho total do backup?
#du -hc $files "$file01" "$file02"
#echo "Tamanho total do backup"
#read
#ls -R $files "$file01" "$file02" | wc -l
#echo "Numero de arquivos"
