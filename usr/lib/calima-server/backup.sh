#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

source /usr/lib/calima-server/funcoes.sh

echo $'#!/bin/bash
source /usr/lib/calima-server/funcoes.sh
if [ ! -d $user_path/calima_backup/ ] ; then
    mkdir ~/calima_backup
    chmod 777 -R ~/calima_backup/
fi

/usr/bin/docker exec -t postgres sh -c "pg_dump -U postgres -Fc calima > /opt/bkp/calima_$(date +%Y%m%d_%H%M%S).backup"
cd $user_path/.calima-server/postgres/bkp/
mv calima* $user_path/calima_backup/'> $user_path/.calima-server/exec.sh
chmod +x $user_path/.calima-server/exec.sh

executar "$user_path/.calima-server/exec.sh" "Efetuando backup do banco, aguarde..."

showNotification "Backup efetuado com exito com o nome de: calima_$(date +%Y%m%d_%H%M%S).backup"

rm -Rf ~/.calima-server/exec.sh
  
xdg-open ~/calima_backup &