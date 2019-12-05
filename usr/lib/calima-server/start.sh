#!/bin/bash
# Descricao: Script de inicializacao
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

FILE=$app_path/tomcat/webapps/calima.war
if [ ! -f "$FILE" ]; then
    download "https://download.projetusti.com.br/calima/java8/calima.war" "$app_path/tomcat/webapps/calima.war"
fi

executar "/usr/bin/docker-compose -f $app_path/postgres.yml -f $app_path/tomcat.yml up -d --remove-orphans" "Iniciando o servidor, aguarde..."
showNotification "Servidor iniciado com sucesso!"
