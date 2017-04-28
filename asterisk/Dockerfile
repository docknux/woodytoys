FROM ubuntu:latest
MAINTAINER Quentin Peten <q.peten@students.ephec.be>

RUN apt-get update && apt-get upgrade -y
RUN apt-get install -y asterisk
RUN sed -i "s/rtpend=20000/rtpend=10009/g" /etc/asterisk/rtp.conf

EXPOSE 10000-10009

CMD /usr/sbin/asterisk -f
