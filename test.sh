#!/bin/bash
sudo pkill mysql
sudo pkill nginx
docker rm -f $(docker ps -aq)
docker rmi $(docker images -aq)
docker build -t igrafana -f srcs/grafana/Dockerfile srcs/grafana/
docker run -d --name grafana -p 3000:3000 igrafana
docker build -t iinfluxdb -f srcs/influxdb/Dockerfile srcs/influxdb/
docker run -d --name influxdb -p 8086:8086 -p 8088:8088 iinfluxdb
docker exec -ti influxdb /bin/sh
#docker exec -ti grafana /bin/sh


