#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

FILE=~/.calima-server/docker-compose.yml
if [ ! -f "$FILE" ]; then
  cp -f /usr/lib/calima-server/docker-compsoe.yml ~/.calima-server
fi

echo $'#!/bin/bash
  cd ~/.calima-server/
  docker-compose up -d postgres_calima'>$user_path/.calima-server/exec.sh
  chmod +x $user_path/.calima-server/exec.sh
  sleep 1
  executar "$user_path/.calima-server/exec.sh" "Iniciando Postgres, aguarde..."


cd ~/.calima-server

  bkpfile=""
  bkpfile=$(zenity --file-selection --class=CalimaServer --title="Selecione o Arquivo de Backup"  --file-filter='Backup do PostgreSQL (.backup) | *.backup' )

      if [ $? = 1 ] ; then
            zenity --question\
                --class=CalimaServer\
                --window-icon=/usr/lib/calima-server/icon.png\
                --text="Deseja selecionar um arquivo?"\
                --height="50" --width="200"
            novoArquivo=$?
            if  [ $novoArquivo = 0 ]; then
              bkpfile=$(zenity --file-selection --class=CalimaServer --title="Selecione o Arquivo de Backup"  --file-filter='Backup do Postgres (.backup) | *.backup' )
            else
             exec $app_path/calima-server.sh
            fi
      fi

  (

  echo "10" ; 
  echo "# Parando o servidor..."
  $app_path/stop.sh
  echo "20" ; 
  echo "# Verificando o arquivo selecionado..."
  rm -rf ~/.calima-server/postgres/bkp/*.*
  cp -f "$bkpfile" ~/.calima-server/postgres/bkp/restaurar.backup
  echo "30" ; 
  echo "# Matando as conexões ao Postgres..."
   /usr/bin/docker exec -it postgres_calima psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'calima';"
  echo "40" ; 
  echo "# Apagando o banco de dados atual..."
  /usr/bin/docker  exec postgres_calima sh -c 'psql -U postgres -c "drop database calima;"'
  echo "50" ; 
  echo "# Criando novo banco..."
  /usr/bin/docker  exec postgres_calima sh -c 'psql -U postgres -c "create database calima;"'
  
  echo "60" ; 
  echo "# Restaurando o banco selecionado..."
  gnome-terminal --title='Calima Server - Processo de Restauração do Banco' --wait --hide-menubar --window --command "/usr/bin/docker exec -t postgres_calima sh -c 'pg_restore -U postgres -v --dbname calima /opt/bkp/restaurar.backup'">/dev/null
  echo "# Banco restaurado com sucesso!" ; 
  echo "90" ;
  echo "# Processo de inicialização executado com êxito!" ; sleep 1
  echo "100" ; sleep 1

  ) |

    zenity --progress --auto-close --no-cancel \
    --height="100" --width="350" \
    --window-icon=/usr/lib/calima-server/icon.png \
    --class=CalimaServer \
    --title="Calima Server" \
    --text="Restauração em andamento, aguarde..." \
    --percentage=0

  showNotification "Restauração do banco de dados concluída!"

  acao=$(zenity  --list  --text "Deseja iniciar esse banco em qual versão ?" \
    --radiolist \
    --window-icon=/usr/lib/calima-server/icon.png \
    --class=CalimaServer \
    --title="Calima Server - v2.0.5" \
    --height="200" --width="280" \
    --column "" \
    --column "Ação" \
    TRUE  "Versão Corrente"\
    FALSE "Versão Canary");

  if [ "$acao" == "Versão Corrente" ] ; then
    exec $app_path/start.sh stable  
  fi

  if [ "$acao" == "Versão Canary" ] ; then
    exec $app_path/start.sh canary
  fi


  showMessage "Restauração do banco concluída mas o servidor ainda está inciando.\nEm 2 minutos, abra no browser o endereço: http://localhost:8081/calima"



