# Parar e remover containers
docker stop postgres_calima
docker stop tomcat_calima
docker rm tomcat_calima
docker rm postgres_calima
docker system prune -a -f

# Remover diretorios de trabalho
sudo rm -Rf ~/.calima-server/*

# Realizar deploy
sudo rm -Rf /usr/lib/calima-server/
sudo cp -r /media/fabiano/HD_Dados/desenvol/calima-server/usr/lib/calima-server/ /usr/lib/
sudo chmod +x /usr/lib/calima-server/*.sh