sudo ufw allow 22/tcp
#For docker swarm
sudo ufw allow 2376/tcp
sudo ufw allow 2377/tcp
sudo ufw allow 7946/tcp
sudo ufw allow 7946/udp
sudo ufw allow 4789/udp

#For containers
sudo ufw allow 3000/tcp
sudo ufw allow 3001/tcp
sudo ufw allow 3002/tcp


#Apply rules
sudo ufw reload
sudo ufw enable
