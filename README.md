# woodytoys

This is a school project.

This repository contains all configuration files necessary to configure a few different services (SIP, mail, web, etc.) on docker.

## Description of the configuration used
We had to deloy this configuration on two vps hosted by OVH. They were both running :
 - Ubuntu 16.04.2 LTS. 
 - Docker 17.03.1-ce, build c6d412e
 - Docker engine 1.27
 - Docker compose 1.12, build b31ff33

## Configuration
First, we need to disable iptables for Docker

create a folder /etc/systemd/system/docker.service.d

# mkdir /etc/systemd/system/docker.service.d

in the folder create a file /etc/systemd/system/docker.service.d/noiptables.conf

[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --iptables=false

Second, restart docker service

#systemctl daemon-reload
#systemctl restart docker

3, enable packet forwarding for IPv4

Uncomment the line
#net.ipv4.ip_forward=1

4, disable IPv6

Add these lines in /etc/sysctl.conf

# Disable IPv6
net.ipv6.conf.all.disable_ipv6 = 1
net.ipv6.conf.default.disable_ipv6 = 1
net.ipv6.conf.lo.disable_ipv6 = 1

5, reload sysctl conf

sysctl -p

3b and 4b

copy vps-config/66-woodytoys.conf to /etc/sysctl.d/

5b

sysctl --system

## Installation

1, launch docker-compose for create all container and network associated

git clone https://github.com/docknux/woodytoys.git
cd woodytoys
docker-compose up -d

2, find the name of the 3 new interface networks created by docker and the internet interface 

ip addr show

3, update the 4 variables in the vps-config/iptables.sh with the name of interfaces

LAN="<to update>"
DMZ="<to update>"
DNS="<to update>"
INTERNET="<to update>"

