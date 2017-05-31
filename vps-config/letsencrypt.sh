#!/bin/sh

# Allow certbot to connect to port 443
sudo iptables -I INPUT  1 -p tcp --dport 443 -j ACCEPT
sudo iptables -I OUTPUT 1 -p tcp --sport 443 -j ACCEPT

# create certificates for wt6.ephec-ti.be and subdomains www, b2b, mail, voip
certbot certonly -n --test-cert --standalone --email sysadmin@wt6.ephec-ti.be \
    -d wt6.ephec-ti.be -d www.wt6.ephec-ti.be \
    -d b2b.wt6.ephec-ti.be \
    -d mail.wt6.ephec-ti.be \
    -d voip.wt6.ephec-ti.be

# Remove iptables rules created for certbot
sudo iptables -D INPUT 1
sudo iptables -D OUTPUT 1
