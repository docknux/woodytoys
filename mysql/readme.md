docker service create --network woodytoys-lan --replicas 1 --name db-b2b -e MYSQL_USER=b2b -e MYSQL_PASSWORD=b2b -e MYSQL_DATABASE=b2b -e MYSQL_ROOT_PASSWORD=true mysql
