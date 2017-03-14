docker service create --network woodytoys-lan --replicas 1 --name db-b2b -p 3306:3306 mysql -e MYSQL_USER=b2b -e MYSQL_PASSWORD=b2b -e MYSQL_DATABASE=b2b
