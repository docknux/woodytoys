docker service create --network woodytoys-lan --replicas 1 --name web-intranet -p 3001:80 docknux/woodytoys-intranet
