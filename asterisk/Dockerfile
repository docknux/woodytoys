FROM ubuntu:latest
MAINTAINER Quentin Peten <q.peten@students.ephec.be>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y asterisk

EXPOSE 10000-10009

VOLUME /etc/asterisk

CMD /usr/sbin/asterisk -f
