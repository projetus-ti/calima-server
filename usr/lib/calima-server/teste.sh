#!/bin/bash
# Descricao: Script de inicializacao
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019
source /usr/lib/calima-server/funcoes.sh
#/usr/bin/docker stop calima_stable
#/usr/bin/docker stop calima_canary 
#/usr/bin/docker  exec postgres_calima sh -c 'psql -U postgres -c "drop database calima;"'
#/usr/bin/docker  exec postgres_calima sh -c 'psql -U postgres -c "create database calima;"'

#gnome-terminal --title='Calima Server - Processo de Restauração do Banco' --wait --hide-menubar --window --command "/usr/bin/docker exec -t postgres_calima sh -c 'pg_restore -U postgres -v --dbname calima /opt/bkp/restaurar.backup'">/dev/null


exec $app_path/start.sh stable 

