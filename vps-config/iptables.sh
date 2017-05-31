#!/bin/sh

###############
## VARIABLES ##
###############

LAN="br-da5103bc5d71"
DMZ="br-9a45e661987e"
DNS="br-29f56b220940"
DOCKER0="docker0"
INTERNET="eth0"

LAN_SUBNET="10.0.0.0/23"
DMZ_SUBNET="10.40.0.0/24"
DNS_SUBNET="10.50.0.0/24"
DOCKER0_SUBNET="172.17.0.0/16"

EXTERN_DNS_CACHE="10.50.0.5"
EXTERN_DNS_SOA="10.50.0.6"
LOCAL_DNS_CACHE="10.0.0.5"
LOCAL_DNS_SOA="10.40.0.5"

APACHE_PROXY="10.40.0.10"
MAIL="10.40.0.20"
SQUID_PROXY="10.0.0.10"
ADMIN_1="10.0.0.80"

####################
## INITIALIZATION ##
####################

# Flush all (user-)predefined existing rules
iptables -F
iptables -X
iptables -t nat -F
iptables -t nat -X

# Set the default policy of filter table to DROP
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

# Set the default policy of nat table to ACCEPT
# Since everything is blocked at the "filter" level
iptables -t nat -P PREROUTING ACCEPT
iptables -t nat -P POSTROUTING ACCEPT
iptables -t nat -P OUTPUT ACCEPT

# Set output translation rules for internet
iptables -t nat -A POSTROUTING -o $INTERNET -s $LAN_SUBNET     -j MASQUERADE
iptables -t nat -A POSTROUTING -o $INTERNET -s $DMZ_SUBNET     -j MASQUERADE
iptables -t nat -A POSTROUTING -o $INTERNET -s $DNS_SUBNET     -j MASQUERADE
iptables -t nat -A POSTROUTING -o $INTERNET -s $DOCKER0_SUBNET -j MASQUERADE

#########
## VPS ##
#########

# Allow loopback
iptables -A INPUT  -i lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT
iptables -A OUTPUT -o lo -s 127.0.0.0/8 -d 127.0.0.0/8 -j ACCEPT

# Allow input/output ICMP/PING
iptables -A INPUT  -i $INTERNET -p icmp -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p icmp -j ACCEPT

# Allow input SSH
iptables -A INPUT  -i $INTERNET -p tcp --dport 22 -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p tcp --sport 22 -j ACCEPT

# Allow output DNS
iptables -A INPUT  -i $INTERNET -p udp --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT  -i $INTERNET -p tcp --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p udp --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p tcp --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow output HTTP
iptables -A INPUT  -i $INTERNET -p tcp --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p tcp --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

# Allow output HTTPS
iptables -A INPUT  -i $INTERNET -p tcp --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A OUTPUT -o $INTERNET -p tcp --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT

#####################
## PORT FORWARDING ##
#####################

# Forward port 53 to extern-dns-soa
iptables -t nat -A PREROUTING -i $INTERNET -p udp --dport 53 -j DNAT --to $EXTERN_DNS_SOA
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 53 -j DNAT --to $EXTERN_DNS_SOA

# Forward port 25 to mail
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 25 -j DNAT --to $MAIL

# Forward port 143 to mail
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 143 -j DNAT --to $MAIL

# Forward port 80 to apache-proxy
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 80 -j DNAT --to $APACHE_PROXY

# Forward port 443 to apache-proxy
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 443 -j DNAT --to $APACHE_PROXY

# Forward port 4022 to employee-1
iptables -t nat -A PREROUTING -i $INTERNET -p tcp --dport 4022 -j DNAT --to $ADMIN_1

##########################
## DOCKER BUILD NETWORK ##
##########################

# Allow DNS from docker0 to internet
iptables -A FORWARD -i $DOCKER0 -o $INTERNET -p udp -s $DOCKER0_SUBNET --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DOCKER0 -o $INTERNET -p tcp -s $DOCKER0_SUBNET --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DOCKER0 -p udp -d $DOCKER0_SUBNET --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DOCKER0 -p tcp -d $DOCKER0_SUBNET --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP from docker0 to internet
iptables -A FORWARD -i $DOCKER0 -o $INTERNET -p tcp -s $DOCKER0_SUBNET --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DOCKER0 -p tcp -d $DOCKER0_SUBNET --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTPS from docker0 to internet
iptables -A FORWARD -i $DOCKER0 -o $INTERNET -p tcp -s $DOCKER0_SUBNET --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DOCKER0 -p tcp -d $DOCKER0_SUBNET --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

######################
## DNS <-> INTERNET ##
######################

# Allow DNS from extern-dns-cache to internet
iptables -A FORWARD -i $DNS -o $INTERNET -p udp -s $EXTERN_DNS_CACHE --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DNS -o $INTERNET -p tcp -s $EXTERN_DNS_CACHE --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DNS -p udp -d $EXTERN_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DNS -p tcp -d $EXTERN_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow DNS from internet to exten-dns-soa
iptables -A FORWARD -i $INTERNET -p udp -d $EXTERN_DNS_SOA --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -p tcp -d $EXTERN_DNS_SOA --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p udp -s $EXTERN_DNS_SOA --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $EXTERN_DNS_SOA --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

######################
## DMZ <-> INTERNET ##
######################

# Allow DNS from dmz_subnet to internet
iptables -A FORWARD -i $DMZ -o $INTERNET -p udp -s $DMZ_SUBNET --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $INTERNET -p tcp -s $DMZ_SUBNET --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DMZ -p udp -d $DMZ_SUBNET --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DMZ -p tcp -d $DMZ_SUBNET --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP from dmz_subnet to internet
iptables -A FORWARD -i $DMZ -o $INTERNET -p tcp -s $DMZ_SUBNET --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DMZ -p tcp -d $DMZ_SUBNET --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTPS from dmz_subnet to internet
iptables -A FORWARD -i $DMZ -o $INTERNET -p tcp -s $DMZ_SUBNET --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $DMZ -p tcp -d $DMZ_SUBNET --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP from internet to apache-proxy
iptables -A FORWARD -i $INTERNET -p tcp -d $APACHE_PROXY --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $APACHE_PROXY --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTPS from internet to apache-proxy
iptables -A FORWARD -i $INTERNET -p tcp -d $APACHE_PROXY --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $APACHE_PROXY --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SMTP from internet to apache-proxy
iptables -A FORWARD -i $INTERNET -p tcp -d $MAIL --dport 25 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $MAIL --sport 25 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow IMAP from internet to apache-proxy
iptables -A FORWARD -i $INTERNET -p tcp -d $MAIL --dport 143 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $MAIL --sport 143 -m state --state ESTABLISHED,RELATED -j ACCEPT

#################
## LAN <-> DNS ##
#################

# Allow DNS from local-dns-cache to extern-dns-cache
iptables -A FORWARD -i $LAN -o $DNS -p udp -s $LOCAL_DNS_CACHE -d $EXTERN_DNS_CACHE --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $LAN -o $DNS -p tcp -s $LOCAL_DNS_CACHE -d $EXTERN_DNS_CACHE --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DNS -o $LAN -p udp -s $EXTERN_DNS_CACHE -d $LOCAL_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DNS -o $LAN -p tcp -s $EXTERN_DNS_CACHE -d $LOCAL_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

#################
## LAN <-> DMZ ##
#################

# Allow DNS from local-dns-cache to local-dns-soa
iptables -A FORWARD -i $LAN -o $DMZ -p udp -s $LOCAL_DNS_CACHE -d $LOCAL_DNS_SOA --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $LAN -o $DMZ -p tcp -s $LOCAL_DNS_CACHE -d $LOCAL_DNS_SOA --dport 53 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p udp -s $LOCAL_DNS_SOA -d $LOCAL_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p tcp -s $LOCAL_DNS_SOA -d $LOCAL_DNS_CACHE --sport 53 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTP from squid_proxy to apache_proxy
iptables -A FORWARD -i $LAN -o $DMZ -p tcp -s $SQUID_PROXY -d $APACHE_PROXY --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p tcp -s $APACHE_PROXY -d $SQUID_PROXY --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTPS from squid_proxy to apache_proxy
iptables -A FORWARD -i $LAN -o $DMZ -p tcp -s $SQUID_PROXY -d $APACHE_PROXY --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p tcp -s $APACHE_PROXY -d $SQUID_PROXY --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SMTP from lan_subnet to mail
iptables -A FORWARD -i $LAN -o $DMZ -p tcp -s $LAN_SUBNET -d $MAIL --dport 25 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p tcp -s $MAIL -d $LAN_SUBNET --sport 25 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow IMAP from lan_subnet to mail
iptables -A FORWARD -i $LAN -o $DMZ -p tcp -s $LAN_SUBNET -d $MAIL --dport 143 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $DMZ -o $LAN -p tcp -s $MAIL -d $LAN_SUBNET --sport 143 -m state --state ESTABLISHED,RELATED -j ACCEPT

######################
## LAN <-> INTERNET ##
######################

# Allow HTTP from squid_proxy to internet
iptables -A FORWARD -i $LAN -o $INTERNET -p tcp -s $SQUID_PROXY --dport 80 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $LAN -p tcp -d $SQUID_PROXY --sport 80 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow HTTPS from squid_proxy to internet
iptables -A FORWARD -i $LAN -o $INTERNET -p tcp -s $SQUID_PROXY --dport 443 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -i $INTERNET -o $LAN -p tcp -d $SQUID_PROXY --sport 443 -m state --state ESTABLISHED,RELATED -j ACCEPT

# Allow SSH tunnel from internet to employee-1
iptables -A FORWARD -i $INTERNET -p tcp -d $ADMIN_1 --dport 4022 -m state --state NEW,ESTABLISHED,RELATED -j ACCEPT
iptables -A FORWARD -o $INTERNET -p tcp -s $ADMIN_1 --sport 4022 -m state --state ESTABLISHED,RELATED -j ACCEPT
