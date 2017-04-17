FROM ubuntu:latest
RUN apt update && apt-get upgrade -y
RUN apt install -y openssh-server htop iproute2 moreutils ssh nano vim net-tools dnsutils iputils-ping telnet alpine
RUN adduser --shell /bin/bash --disabled-password test
RUN echo "test:test" | chpasswd
RUN mkdir /var/run/sshd
CMD /usr/sbin/sshd -D -p 4022
EXPOSE 4022
