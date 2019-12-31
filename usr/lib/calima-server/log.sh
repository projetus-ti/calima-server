#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

/usr/bin/docker logs tomcat 2>&1 | zenity --class=CalimaServer --window-icon=/usr/lib/calima-server/icon.png --text-info --auto-scroll --no-interaction --font=mono --title "Calima Server - Log do Sistema" --width 1200 --height 700
