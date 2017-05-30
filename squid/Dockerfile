FROM sameersbn/squid:latest
MAINTAINER Denis Pettens <denis.pettens@gmail.com>

# Install apache2-utils for authentification program
RUN set -x \
    && apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y apache2-utils \
    && rm -rf /var/lib/apt/lists/*

# Create two http proxy users for authentification
RUN set -x \
    && touch /etc/squid3/users \
    && htpasswd –b /etc/squid3/users admin-1 admin-1 \
    && htpasswd –b /etc/squid3/users employee-1 employee-1 \ 
