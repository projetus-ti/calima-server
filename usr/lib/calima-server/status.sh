#!/bin/bash
# Descricao: Script de status
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

gnome-terminal --title='Calima Server - Status dos Serviços' --hide-menubar --maximize --window --command '/usr/bin/docker stats'
sleep 5
