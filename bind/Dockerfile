FROM alpine:latest
MAINTAINER Denis Pettens <denis.pettens@gmail.com>

# Install bind
RUN set -x \
    && apk update \
    && apk add --upgrade bind \
    && rm -rf /var/cache/apk/*

EXPOSE 53/udp
EXPOSE 53/tcp

COPY ./dns/etc/named.conf /etc/bind/named.conf
COPY ./dns/var/db.wt6.ephec-ti.be /var/bind/
CMD ["named", "-g", "-c", "/etc/bind/named.conf", "-u", "named"]
