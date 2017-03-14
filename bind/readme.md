docker service create --network woodytoys-lan --replicas 1 --name bind -p 53:53 docknux/woodytoys-bind
