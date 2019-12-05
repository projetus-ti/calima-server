#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

#Cria a pasta oculta onde vão os arquivos para execução.
mkdir -p ~/.calima-server/

checkPostgresTomcat

checkUser

cd $app_path

  acao=$(zenity  --list  --text "Selecione a ação desejada:" \
    --radiolist \
    --class=CalimaServer \
    --title="Calima Server" \
    --height="300" --width="280" \
    --column "" \
    --column "Ação" \
    TRUE  "Iniciar o Servidor" \
    FALSE "Parar o Servidor"\
    FALSE "Atualizar Versão Corrente"\
    FALSE "Atualizar Versão Canary"\
    FALSE "Status dos Serviços"\
    FALSE "Log do Sistema"\
    FAlSE "Restaurar Backup"\
    FALSE "Fazer Backup");

  if [ $? = 1 ] ; then
    exit 0
  fi

  if [ "$acao" = "Iniciar o Servidor" ] ; then
    $app_path/start.sh
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Parar o Servidor" ] ; then
    $app_path/stop.sh
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Status dos Serviços" ] ; then
    $app_path/status.sh
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Log do Sistema" ] ; then
    $app_path/log.sh
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Fazer Backup" ] ; then
    $app_path/backup.sh
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Restaurar Backup" ] ; then
    $app_path/res_backup.sh 
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Atualizar Versão Corrente" ] ; then
    $app_path/update.sh "normal"
    $app_path/calima-server.sh
  fi

  if [ "$acao" = "Atualizar Versão Canary" ] ; then
    $app_path/update.sh "canary"
    $app_path/calima-server.sh
  fi
exit