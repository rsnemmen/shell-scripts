#!/bin/sh
# Monta os diretórios relevantes do pcastro20
#
# De preferência, crie uma chave para que não precise digitar as
# senhas sempre que fazer login.
# Ver http://en.jakilinux.org/apps/ssh-tricks/

sshfs -o ServerAliveInterval=15 pcastro20: ~/pcastro20/home
sshfs -o ServerAliveInterval=15 pcastro20:./downloads ~/pcastro20/downloads
sshfs -o ServerAliveInterval=15 pcastro20:./iso ~/pcastro20/iso