FROM ubuntu:latest
RUN apt update && apt-get upgrade -y && apt install -y htop iproute2 moreutils ssh nano vim net-tools dnsutils iputils-ping
CMD echo nameserver $DNS > /etc/resolv.conf ; /bin/bash
