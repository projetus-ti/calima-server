#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

bkpfile=""

if [ "$1" == "Referencial" ] ; then
  bkpfile="$user_path/.calima-server/backup/calima.backup"
else 
  bkpfile=$(zenity --file-selection --class=CalimaServer --title="Selecione o Arquivo de Backup"  --file-filter='Backup do PostgreSQL (.backup) | *.backup' )
fi
  
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
  /usr/bin/docker stop tomcat_calima
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
  

  cmdDocker="/usr/bin/docker exec -t postgres_calima sh -c 'pg_restore -U postgres -v --dbname calima /opt/bkp/restaurar.backup'"
  gnome-terminal --title='Calima Server - Processo de Restauração do Banco' --wait --hide-menubar --window --command "$cmdDocker">/dev/null
  echo "# Iniciando o Tomcat, aguarde..." ; 
  /usr/bin/docker start tomcat_calima
  echo "90" ;
  echo "# Processo concluído com sucesso." ; sleep 1
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

  showMessage "Restauração do banco concluída mas o servidor ainda está inciando.\nEm 2 minutos, abra no browser o endereço: http://localhost:8081/calima"



