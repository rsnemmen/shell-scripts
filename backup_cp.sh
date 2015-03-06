# Rotina simples para fazer backup usando o cp. Infelizmente o rsync
# esta' dando problemas.

# Arquivos a serem copiados
dir="$HOME/data" #diretorio onde estao os subdiretorios abaixo
files="backup_desktop doc organize work list.txt"

echo "Certifique-se de que montou /media/HD120GB com ntfs-3g (root)!"
echo " 1. Plugue o dispositivo, verifique se ele foi montado corretamente com ntfs-3g"
echo "Prosseguir? (ENTER - sim ou CTRL-C - n�)"
read REPLY
echo " 2. Rode o truecrypt com o comando: "
echo "$ truecrypt --filesystem ntfs-3g /media/HD120GB/backup_laptop.tc /mnt/tc"
echo "Truecrypt funcionou corretamente?"
read REPLY

echo "Va' para /mnt/tc e apague voce mesmo os arquivos antigos, bem como os mp3s!"
read REPLY

cd $dir
cp -pRLv $files /mnt/tc
cd ~

# Agora copia os mp3s
cp -pRLv $dir/mp3 /media/HD120GB/mp3
