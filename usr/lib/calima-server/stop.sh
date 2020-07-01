#!/bin/bash
# Descricao: Script de parada
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

# Criar script para execucao da acao
echo $'#!/bin/bash
docker-compose -f /usr/lib/calima-server/docker-compose.yml down --remove-orphans'>$user_path/.calima-server/exec.sh

# Dar permissao de execucao ao script
chmod +x $user_path/.calima-server/exec.sh

# Executar script
executar "$user_path/.calima-server/exec.sh" "Parando os serviços, aguarde..."

# Notificar o usuario
showNotification "Calima finalizado com sucesso!"
