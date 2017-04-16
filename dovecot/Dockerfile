FROM alpine:latest
MAINTAINER Quentin Peten <he201521@students.ephec.be>

# Install bind
RUN set -x \
    && apk update \
    && apk add --upgrade dovecot \
    && rm -rf /var/cache/apk/*

EXPOSE 143/tcp
EXPOSE 993/tcp
EXPOSE 110/tcp
EXPOSE 995/tcp

RUN adduser -DH vmail
RUN mkdir /home/vmail
RUN chown vmail:vmail /home/vmail
VOLUME  /home/vmail

RUN rm -r /etc/dovecot/*
COPY dovecot.conf /etc/dovecot/dovecot.conf
COPY passwd /etc/dovecot/passwd

CMD ["dovecot", "-F"]
