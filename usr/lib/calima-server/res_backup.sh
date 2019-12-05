#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

  bkpfile=""
  bkpfile=$(zenity --file-selection --class=CalimaServer --title="Selecione o Arquivo de Backup"  --file-filter='Backup do PostgreSQL (.backup) | *.backup' )

      if [ $? = 1 ] ; then
            zenity --question\
                --class=CalimaServer
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
  $app_path/parar.sh
  echo "20" ; 
  echo "# Verificando o arquivo selecionado..."
  cp -f "$bkpfile" /usr/lib/calima-server/postgres/bkp/restaurar.backup
  echo "30" ; 
  echo "# Matando as conexões ao Postgres..."
  /usr/bin/docker exec -it postgres psql -U postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = 'calima';"
  echo "40" ; 
  echo "# Apagando o banco de dados atual..."
  /usr/bin/docker exec -t postgres sh -c "psql -U postgres -c 'drop database calima;'"
  echo "50" ; 
  echo "# Criando um novo banco..."
  /usr/bin/docker exec -t postgres sh -c "psql -U postgres -c 'create database calima;'"
  echo "60" ; 
  echo "# Restaurando o banco selecionado..."

  gnome-terminal --title='Calima Server - Processo de Restauração do Banco' --wait --hide-menubar --window --command "/usr/bin/docker exec -t postgres sh -c 'pg_restore -U postgres -v --dbname calima /opt/bkp/restaurar.backup'">/dev/null
 
  echo "# Verificando o arquivo war..."
  FILE=$app_path/tomcat/webapps/calima.war
  if [ ! -f "$FILE" ]; then
    download "https://download.projetusti.com.br/calima/java8/calima.war" "$app_path/tomcat/webapps/calima.war"
  fi
  echo "# Banco restaurado com sucesso!" ; 
  echo "90" ;
  echo "# Inicializando o Calima Server..." ; sleep 1
  $app_path/iniciar.sh
  echo "# Processo de inicialização executado com êxito!" ; sleep 1
  echo "100" ; sleep 1

  ) |

    zenity --progress --auto-close --no-cancel \
    --height="100" --width="350" \
    --class=CalimaServer \
    --title="Calima Server" \
    --text="Restauração em andamento, aguarde..." \
    --percentage=0

  showNotification "Restauração do banco de dados concluída!"

  showMessage "Restauração do banco concluída mas o servidor ainda está inciando.\nEm 2 minutos, abra no browser o endereço: http://localhost:8081/calima"