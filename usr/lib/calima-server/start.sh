#!/bin/bash
# Descricao: Script de inicializacao
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

docker=$1
cd /usr/lib/calima-server/

if [ "$docker" == "stable" ] ; then
    echo $'#!/bin/bash
    cp /usr/lib/calima-server/docker-compose.yml ~/.calima-server/
    cd ~/.calima-server/
    docker system prune -a --force
    docker-compose down --remove-orphans
    docker pull projetusti/calima:stable
    docker-compose up -d calima_stable'>$user_path/.calima-server/exec.sh
    chmod +x $user_path/.calima-server/exec.sh
    sleep 1
    executar "$user_path/.calima-server/exec.sh" "Iniciando Calima Corrente, aguarde..."
fi

if [ "$docker" == "canary" ] ; then
    echo $'#!/bin/bash
    cp /usr/lib/calima-server/docker-compose.yml ~/.calima-server/
    cd ~/.calima-server/
    docker system prune -a --force
    docker-compose down --remove-orphans
    docker pull projetusti/calima:canary
    docker-compose up -d calima_canary'>$user_path/.calima-server/exec.sh
    chmod +x $user_path/.calima-server/exec.sh
    sleep 1
    executar "$user_path/.calima-server/exec.sh" "Iniciando Calima Canary, aguarde..."
fi




showNotification "Servidor iniciado com sucesso!"
