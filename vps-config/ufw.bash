#!/bin/bash

sudo ufw reset

#Spammers (SIP)
sudo ufw deny from 85.93.93.173 to any
sudo ufw deny from 172.17.0.1 to any
sudo ufw deny from 62.138.14.22 to any

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
sudo ufw allow 443/tcp

#For mail
sudo ufw allow 25/tcp
sudo ufw allow 587/tcp
sudo ufw allow 143/tcp
sudo ufw allow 993/tcp
sudo ufw allow 110/tcp
sudo ufw allow 995/tcp

#For Asterisk
sudo ufw allow 10000:10009/tcp
sudo ufw allow 10000:10009/udp
sudo ufw allow 5060/tcp
sudo ufw allow 5060/udp
sudo ufw allow 4569/tcp
sudo ufw allow 4569/udp
sudo ufw allow 5036/tcp
sudo ufw allow 5036/udp

#Apply rules
sudo ufw reload
sudo ufw enable
