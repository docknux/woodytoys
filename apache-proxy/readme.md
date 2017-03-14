docker service create --network woodytoys-lan --replicas 1 --name apache-proxy -p 80:80 docknux/woodytoys-apache-proxy
