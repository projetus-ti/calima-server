#!/bin/bash
# Descricao: Script de de controle do calima server
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

# Executar rotina de backup
cmdDocker="/usr/bin/docker exec -t postgres_calima sh -c 'pg_dump -U postgres -v -Fc calima > /opt/bkp/calima_$(date +%Y%m%d_%H%M%S).backup'"
gnome-terminal --title='Calima Server - Processo de Restauração do Banco' --wait --hide-menubar --window --command "$cmdDocker">/dev/null

# Notificar o fim da rotina
showNotification "Backup efetuado com exito com o nome de: calima_$(date +%Y%m%d_%H%M%S).backup"
  
# Abrir o diretorio de destino de backup
xdg-open $user_path/.calima-server/postgres/bkp/ &
