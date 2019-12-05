#!/bin/bash
# Descricao: Script de parada
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

echo $'#!/bin/bash 
/usr/bin/docker stop tomcat 
/usr/bin/docker rm tomcat'>~/.calima-server/exec.sh
chmod +x ~/.calima-server/exec.sh
sleep 1
executar "$user_path/.calima-server/exec.sh" "Parando o servidor, aguarde..."

showNotification "Servidor finalizado com sucesso!"
rm -rf ~/.calima-server/exec.sh