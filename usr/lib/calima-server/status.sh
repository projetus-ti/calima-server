#!/bin/bash
# Descricao: Script de status
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

# Executar a acao dentro do gnome terminal, para o usuario ter feedback visual
gnome-terminal --title='Calima Server - Status dos Serviços' --hide-menubar --maximize --window --command '/usr/bin/docker stats'

# Pausar o retorno para nao voltar bruscamente pro menu
sleep 3
