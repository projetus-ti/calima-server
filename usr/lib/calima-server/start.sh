#!/bin/bash
# Descricao: Script de inicializacao
# Autor: Evandro Begati e Fabiano Henrique
# Data: 21/11/2019

# Dependencias
source /usr/lib/calima-server/funcoes.sh

# Declarar variavel de trabalho
docker=$1

# Parando serviços 
$app_path/stop.sh

if [ $docker = "testing" ] ; then
  TDIR=~/.calima-server/docker-calima/calima

  if [ ! -d "$TDIR" ]; then
    cd ~/.calima-server/
    executar "git clone https://github.com/projetus-ti/docker-calima.git" "Baixando a versao Testing, aguarde..."
  fi

  git -C ~/.calima-server/docker-calima reset --hard origin/testing
  executar "git -C ~/.calima-server/docker-calima pull origin testing" "Baixando a versao Testing, aguarde..."
  executar "docker-compose -f /usr/lib/calima-server/docker-compose.yml build" "Construindo a imagem Testing, aguarde..."
fi

# Criar script para execucao da acao
echo $'#!/bin/bash
  docker pull projetusti/calima:'$docker'
  docker-compose -f /usr/lib/calima-server/docker-compose.yml up -d calima_'$docker'
  docker system prune -a -f'>$user_path/.calima-server/exec.sh

# Dar permissao de execucao ao script
chmod +x $user_path/.calima-server/exec.sh

# Executar script
executar "$user_path/.calima-server/exec.sh" "Atualizando e Iniciando o Calima, aguarde..."

# Notificar o usuario
showNotification "Calima iniciado com sucesso!"
