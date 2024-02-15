#!/bin/sh
#
# Script que cria a imagem de um cd/dvd e a prepara para upload
# para o exterior (fora da UFRGS).

echo "Insira o cd ou dvd que vai ser enviado."
echo "Pressione ENTER quando estiver pronta."
read
dd if=/dev/dvd of=upload.iso

echo
echo "Imagem do disco criada no HD!"
echo
echo "Iniciando compactacao do arquivo da imagem...... "
echo "NOTA: isto pode demorar varios minutos, dependendo da CPU"
echo "         e do tamanho da imagem!"
echo
gzip -v upload.iso
echo
echo "Compactacao finalizada!"

echo
echo "Transferindo arquivo para servidor......"
echo

echo "As informacoes do arquivo original sao:" > md5sum.txt
ls -l upload.iso.gz >> md5sum.txt
echo >> md5sum.txt
echo "O novo arquivo chama-se data." >> md5sum.txt
mv upload.iso.gz data
echo "MD5SUM da imagem:" >> md5sum.txt
md5sum data >> md5sum.txt

# O ideal é que o acesso ssh no servidor tenha sido configurado
# para não precisar de senhas.
# Ver http://en.jakilinux.org/apps/ssh-tricks/
scp data md5sum.txt visitor@pcastro20:./dados2
rm -f data md5sum.txt

echo
echo "PRONTO!!"