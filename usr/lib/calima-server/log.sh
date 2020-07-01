#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

# Executar rotina de log
/usr/bin/docker logs tomcat_calima --follow 2>&1 | zenity --class=CalimaServer --window-icon=/usr/lib/calima-server/icon.png --text-info --auto-scroll --no-interaction --font=mono --title "Calima - Log do Tomcat" --width 12050 --height 700
