# Woodytoys

This is a school project.

This repository contains all configuration files necessary to configure a few different services (SIP, mail, web, etc.) on docker.

## Description of the configuration used
We had to deloy this configuration on two vps hosted by OVH. They were both running :

 - Ubuntu 16.04.2 LTS.
 - Docker 17.03.1-ce, build c6d412e
 - Docker engine 1.27
 - Docker compose 1.13, build 1719ceb

## Configuration
### Docker

We need to disable iptables from Docker to avoid to prevent them interfered with ours.
For this, simply a config file for the docker.service of systemd.

1. Create a `docker.service.d` folder in `/etc/systemd/`.

```
# mkdir /etc/systemd/system/docker.service.d
```

2. In this folder, create a file `/etc/systemd/system/docker.service.d/noiptables.conf` and copy these lines in.

```
[Service]
ExecStart=
ExecStart=/usr/bin/docker daemon -H fd:// --iptables=false
```

3. Reload systemd manager configuration

```
# systemctl daemon-reload
```

4. Relaod `docker.service`

```
# systemctl restart docker
```

### Sysctl
We need to edit kernel parameters for enable ip packet forwarding and disable IPv6.
So, we'll be able to routing packets between the different subnets.
Moreover as we only work with IPv4, we avoid security gap with IPv6.

1. Copy the file `vps-config/66-woodytoys.conf` in `/etc/sysctl.d/`

2. Restart the system to apply these settings.

## Installation

1. Install docker (first check to see if the version in your repo is recent enough, otherwise use this method.)

```
$ sudo apt-get remove docker docker-engine
$ sudo apt-get update
$ sudo apt-get install \
    linux-image-extra-$(uname -r) \
    linux-image-extra-virtual
$ sudo apt-get install \
    apt-transport-https \
    ca-certificates \
    curl \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
```
Please check that the fingerprint actually is `9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88`.
```
$ sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
$ sudo apt-get update
$ sudo apt-get install docker-ce
```

2. Launch `docker-compose` command to create all containers and networks.

```
$ git clone https://github.com/docknux/woodytoys.git
$ cd woodytoys/
$ docker-compose up -d
```

3. Find the name of the internet network interface and the three new network interfaces created by Docker.

```
$ ip addr show
```

4. Update the 4 variables in the `vps-config/iptables.sh` with the name of interfaces.

```
LAN="<to update>"
DMZ="<to update>"
DNS="<to update>"
INTERNET="<to update>"
```

5. Launch the `vps-config/iptables.sh` script to enable iptables.

```
# vps-config/iptables.sh
```

5. Check that all containers are up

```
$ docker ps -a
```

6. Test if all goes well in following the [wiki](https://github.com/docknux/woodytoys/wiki). And, if it's okay, you can make everything persist between reboots.

```
TODO: iptables and docker
```
