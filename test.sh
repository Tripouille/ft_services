#!/bin/bash
docker rm -f $(docker ps -aq)
docker rmi $(docker images -aq)
sudo pkill mysql nginx
docker rm -f wp mysql
docker rmi mwp mmysql
docker build -t pmai -f srcs/phpmyadmin/Dockerfile srcs/phpmyadmin/
docker run -d --name pma -p 5000:5000 pmai
docker exec -ti pma /bin/sh

