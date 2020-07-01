#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

# Criar diretorio de trabalho
mkdir -p ~/.calima-server/postgres/bkp
mkdir -p ~/.calima-server/tomcat/work
mkdir -p ~/.calima-server/docker-calima

# Verificar se o usuario corrente esta adicionado ao grupo docker
checkUser

# Declarar variavel para o diretorio do postgres
PGDATA=~/.calima-server/postgres/data/

# Verificar se ha banco de dados no diretorio de trabalho, caso contrario, criar com o banco referencial
if [ ! -d "$PGDATA" ]; then
  # Subir o postgres
  executar "docker-compose -f /usr/lib/calima-server/docker-compose.yml up -d postgres_calima" "Iniciando o PostgreSQL..."

  # Pausar 30 segundos, para esperar o docker criar a estrutura do diretorio data
  executar "sleep 30" "Aguarde, criando uma nova estrutura de banco de dados..."

  # Entrar no diretorio de backup
  cd ~/.calima-server/

  # Baixar o banco referencial e restaura-lo
  executar "wget https://download.projetusti.com.br/calima/banco-referencial.zip --no-check-certificate -O banco-referencial.zip" "Baixando arquivos necessários."
  unzip banco-referencial.zip
  $app_path/res_backup.sh "Referencial"
  rm -rf banco-referencial.zip
  rm -rf ~/.calima-server/backup/

  # Iniciar o sistema com a versao estavel
  $app_path/start.sh "stable"
fi

# Entrar no diretorio de trabalho
cd $app_path

# Menu
acao=$(zenity  --list  --text "Selecione a ação desejada:" \
    --radiolist \
    --window-icon=/usr/lib/calima-server/icon.png \
    --class=CalimaServer \
    --title="Calima Server - v3.0.0" \
    --height="330" --width="280" \
    --column "" \
    --column "Ação" \
    TRUE  "Iniciar o Versão Stable"\
    FALSE "Iniciar o Versão Canary"\
    FALSE "Iniciar o Versão Testing"\
    FALSE "Parar"\
    FALSE "Status"\
    FALSE "Log"\
    FAlSE "Restaurar Backup"\
    FALSE "Realizar Backup");

if [ $? = 1 ] ; then
  exit 0
fi

# Acoes do menu
if [ "$acao" = "Iniciar o Versão Stable" ] ; then
  $app_path/start.sh "stable"
  $app_path/calima-server.sh
fi

if [ "$acao" = "Iniciar o Versão Canary" ] ; then
  $app_path/start.sh "canary"
  $app_path/calima-server.sh
fi

if [ "$acao" = "Iniciar o Versão Testing" ] ; then
  $app_path/start.sh "testing"
  $app_path/calima-server.sh
fi

if [ "$acao" = "Parar" ] ; then
  $app_path/stop.sh
  $app_path/calima-server.sh
fi

if [ "$acao" = "Status" ] ; then
  $app_path/status.sh
  $app_path/calima-server.sh
fi

if [ "$acao" = "Log" ] ; then
  $app_path/log.sh
  $app_path/calima-server.sh
fi

if [ "$acao" = "Realizar Backup" ] ; then
  $app_path/backup.sh
  $app_path/calima-server.sh
fi

if [ "$acao" = "Restaurar Backup" ] ; then
  $app_path/res_backup.sh 
  $app_path/calima-server.sh
fi

exit
