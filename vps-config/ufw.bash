#!/bin/bash

#Misc ports
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
sudo ufw allow 53/tcp
sudo ufw allow 53/udp
sudo ufw allow 80/tcp

#For mail
sudo ufw allow 143/tcp
sudo ufw allow 993/tcp
sudo ufw allow 110/tcp
sudo ufw allow 995/tcp

#Apply rules
sudo ufw reload
sudo ufw enable
