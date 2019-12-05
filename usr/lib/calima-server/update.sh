#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

if [ "$1" = "normal" ] ; then
  url="https://download.projetusti.com.br/calima/java8/calima.war"
fi


if [ "$1" = "canary" ] ; then
  url="https://download.projetusti.com.br/calima/canary/calima.war"
fi

 (
  echo "10" ; sleep 1
  echo "# Parando os serviços..."
  $app_path/parar.sh
  echo "50" ; sleep 1
  echo "# Efetuando o download da atualização..."
  FILE=./tomcat/webapps/calima.war
  download "$url" "./tomcat/webapps/calima.war"
  echo "70" ; sleep 1
  echo "# Reiniciando serviços..."  
  $app_path/iniciar.sh
  echo "# Processo concluído!" ; sleep 1
  echo "100" ; sleep 1
    ) |

    zenity --progress --auto-close  --no-cancel \
    --height="100" --width="350" \
    --class=CalimaServer
    --title="Calima Server" \
    --text="Atualiação em andamento. Por favor, aguarde!" \
    --percentage=0

   showNotification "Atualização concluída com êxito!"

  showMessage "Atualização concluída mas o servidor ainda está inciando.\nEm 2 minutos, abra no browser o endereço: http://localhost:8081/calima ou\nAcessar pelo Calima App"
