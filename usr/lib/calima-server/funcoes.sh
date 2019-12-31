#!/bin/bash
# Descricao: Funcoes do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 20/11/2019

# Setar outras variaveis
desktop_path=$(xdg-user-dir DESKTOP)
user_path=$(xdg-user-dir USER)
app_path="/usr/lib/calima-server"
app_reboot="~/.calima-server"
WmClass="CalimaServer"
usr=$(whoami)
exist=$(id -Gn "$usr"|grep -c "docker" )

checkPostgresTomcat(){
if [ ! -d ~/.calima-server/tomcat -a ! -d ~/.calima-server/postgres ] ; then
    (
      echo "10" 
      echo "# Copiando arquivos Tomcat..."
      cp -rf /usr/lib/calima-server/tomcat  ~/.calima-server
      echo "50"
      echo "# Copiando arquivos Postgres..."
      cp -rf /usr/lib/calima-server/postgres  ~/.calima-server
      echo "100"
      echo "# Copia conclúida..."
      sleep 1
    ) |

    zenity --progress --auto-close --no-cancel \
    --height="100" --width="350" \
    --window-icon=/usr/lib/calima-server/icon.png \
    --class=CalimaServer \
    --title="Calima Serve" \
    --text="Copiando arquivos, aguarde..." \
    --percentage=0
fi
}

checkReboot(){
  if [ -e ~/.calima-server/reiniciar.ini ] ; then

    dia=$(date "+%A")
    mes=$(date "+%b")

    #echo $dia

    if [ "$dia" == "segunda" ] ; then
      dia="Mon"
    fi

    if [ "$dia" == "terça" ] ; then
      dia="Tue"
    fi
    if [ "$dia" == "quarta" ] ; then
      dia="Wed"
    fi

    if [ "$dia" == "quinta" ] ; then
      dia="Thu"
    fi

    if [ "$dia" == "sexta" ] ; then
      dia="Fri"
    fi

    if [ "$dia" == "sabado" ] ; then
      dia="Sat"
    fi

    if [ "$dia" == "domingo" ] ; then
      dia="San"
    fi

    #echo $mes

    if [ "$mes" == "fev" ] ; then
      mes="Feb"
    fi

    if [ "$mes" == "mar" ] ; then
      mes="Mar"
    fi

    if [ "$mes" == "abr" ] ; then
       mes="Apr"
    fi

    if [ "$mes" == "mai" ] ; then
      mes="May"
    fi

    if [ "$mes" == "jun" ] ; then
      mes="Jun"
    fi

    if [ "$mes" == "jul" ] ; then
       mes="Jul"
    fi

    if [ "$mes" == "ago" ] ; then
      mes="Aug"
    fi

    if [ "$mes" == "set" ] ; then
       mes="Sep"
    fi

    if [ "$mes" == "out" ] ; then
      mes="Oct"
    fi

    if [ "$mes" == "nov" ] ; then
      mes="Nov"
    fi

    if [ "$mes" == "dez" ] ; then
      mes="Dec"
    fi

    reiniciado=$(last -x reboot | grep -i "$dia $mes" | wc -l)
    #echo $reinciado
    vezes=$(head -1 ~/.calima-server/reiniciar.ini)

    if [ $reiniciado == $vezes ] ; 
    then
      zenity --info --class=CalimaServer\
      --window-icon=/usr/lib/calima-server/icon.png \
      --height="50" --width="500" \
      --text="\nComputador precisa ser reiniciado para que o Calima Server funcione corretamente!"
      exit -1 
    else
      #zenity --info --height="50" --width="150" --class=CalimaServer \
      #       --text="Reinicio identificado!"
      rm -rf ~/.calima-server/reiniciar.ini
    fi
  fi
}

checkUser(){
  if  [ $exist == 0 ] ;  then
    dia=$(date "+%A")
    mes=$(date "+%b")
    #echo $dia

    if [ "$dia" == "segunda" ] ; then
      dia="Mon"
    fi

    if [ "$dia" == "terça" ] ; then
      dia="Tue"
    fi
    if [ "$dia" == "quarta" ] ; then
      dia="Wed"
    fi

    if [ "$dia" == "quinta" ] ; then
      dia="Thu"
    fi

    if [ "$dia" == "sexta" ] ; then
      dia="Fri"
    fi

    if [ "$dia" == "sabado" ] ; then
      dia="Sat"
    fi

    if [ "$dia" == "domingo" ] ; then
      dia="San"
    fi

    #echo $mes

    if [ "$mes" == "fev" ] ; then
      mes="Feb"
    fi

    if [ "$mes" == "mar" ] ; then
      mes="Mar"
    fi

    if [ "$mes" == "abr" ] ; then
      mes="Apr"
    fi

    if [ "$mes" == "mai" ] ; then
      mes="May"
    fi

    if [ "$mes" == "jun" ] ; then
      mes="Jun"
    fi

    if [ "$mes" == "jul" ] ; then
      mes="Jul"
    fi

    if [ "$mes" == "ago" ] ; then
      mes="Aug"
    fi

    if [ "$mes" == "set" ] ; then
      mes="Sep"
    fi

    if [ "$mes" == "out" ] ; then
      mes="Oct"
    fi

    if [ "$mes" == "nov" ] ; then
       mes="Nov"
    fi

    if [ "$mes" == "dez" ] ; then
      mes="Dec"
    fi

    mkdir -p ~/.calima-server
    vezes=$(last -x reboot | grep -i "$dia $mes" | wc -l)
    #echo $vezes
    echo "$vezes"> ~/.calima-server/reiniciar.ini
    
    executar "pkexec adduser -a "$usr" docker" "Dando permissão ao usuário atual..."
    zenity --info \
    --window-icon=/usr/lib/calima-server/icon.png \
    --height="120" --width="600" \
    --text="Foi dada permissão ao seu usuário para poder executar algumas ações principais do Calima Server.\nPor isso, se faz necessário reinciar o computador.\nPor favor reinicie o computador para que funcione todas as funções do Calima Server."
    exit -1
  else
    checkReboot
  fi
}



download() {
  cd $app_path
  rm -Rf $2
  rand="$RANDOM `date`"
  pipe="/tmp/pipe.`echo '$rand' | md5sum | tr -d ' -'`"
  mkfifo $pipe
  wget -c $1 --no-check-certificate -O $2 2>&1 | while read data;do
    if [ "`echo $data | grep '^Tamanho:'`" ]; then
      total_size=`echo $data | grep "^Tamanho:" | sed 's/.*\((.*)\).*/\1/' |  tr -d '()'`
    fi
    if  [ "`echo $data | grep '^Length:'`" ]; then
      total_size=`echo $data | grep "^Length:" | sed 's/.*\((.*)\).*/\1/' |  tr -d '()'`
    fi

    if [ "`echo $data | grep '[0-9]*%' `" ];then
      percent=`echo $data | grep -o "[0-9]*%" | tr -d '%'`
      current=`echo $data | grep "[0-9]*%" | sed 's/\([0-9BKMG.]\+\).*/\1/' `
      speed=`echo $data | grep "[0-9]*%" | sed 's/.*\(% [0-9BKMG.]\+\).*/\1/' | tr -d ' %'`
      remain=`echo $data | grep -o "[0-9A-Za-z]*$" `
      echo $percent
      echo "#Baixando: $1\n\n$current de $total_size ($percent%)\n\nTempo estimado: $remain"
    fi
  done > $pipe &
 
  wget_info=`ps ax |grep "wget.*$1" |awk '{print $1"|"$2}'`
  wget_pid=`echo $wget_info|cut -d'|' -f1 `
 
  zenity --class=CalimaServer --progress --auto-close --window-icon=/usr/lib/calima-server/icon.png --auto-kill --text="Efetuando o download do arquivo: $1\n\n" --width="500" --title "Calima Server"< $pipe
  if [ "`ps -A |grep "$wget_pid"`" ];then
    kill $wget_pid
  fi
  rm -f $pipe
  rm -Rf $app_path/wget-log*
}

showMessage() {
    zenity --class=CalimaServer --window-icon=/usr/lib/calima-server/icon.png --info --icon-name='dialog-warning' --title "Calima Server" \
         --text "$1" \
         --height="50" --width="450"
}

showNotification(){
  zenity --class=CalimaServer --window-icon=/usr/lib/calima-server/icon.png --notification --icon-name='dialog-warning' --title "Calima Server" \
         --text "$1" \
         --height="50" --width="600"
}

executar() {
  cd ~/.calima-server
  response=$($1) | zenity --progress --window-icon=/usr/lib/calima-server/icon.png --class=CalimaServer --text="$2" --pulsate --class=CalimaServer --no-cancel --auto-close --title "Calima Server"
  echo $response
}
