#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

echo $'#!/bin/bash
source /usr/lib/calima-server/funcoes.sh
if [ ! -d $user_path/calima_backup/ ] ; then
    mkdir $user_path/calima_backup
    chmod 777 $user_path/calima_backup/
fi

/usr/bin/docker exec -t postgres sh -c "pg_dump -U postgres -Fc calima > /opt/bkp/calima_$(date +%Y%m%d_%H%M%S).backup"
#chmod 777 -R '$app_path'/postgres/bkp/
sleep 2
cp -rf /usr/lib/calima-server/postgres/bkp/calima*  ~/calima_backup/'> ~/.calima-server/exec.sh
chmod +x ~/.calima-server/exec.sh

executar "$user_path/.calima-server/exec.sh" "Efetuando backup do banco, aguarde..."

showNotification "Backup efetuado com exito com o nome de: calima_$(date +%Y%m%d_%H%M%S).backup"
  
xdg-open ~/calima_backup & 

sleep 3
rm -Rf $app_path/exec.sh
