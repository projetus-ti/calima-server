#!/bin/bash
# Descricao: Script de parada
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

echo $'#!/bin/bash 
docker-compose stop calima_stable
docker-compose rm -f calima_stable
docker-compose stop calima_canary
docker-compose rm -f calima_canary'>$user_path/.calima-server/exec.sh
chmod +x $user_path/.calima-server/exec.sh
sleep 1
executar "$user_path/.calima-server/exec.sh" "Parando o servidor, aguarde..."

showNotification "Servidor finalizado com sucesso!"
rm -rf $user_path/.calima-server/exec.sh