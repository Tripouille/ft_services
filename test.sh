#!/bin/bash
sudo pkill mysql nginx
docker rm -f wp mysql
docker rmi mwp mmysql
docker build -t mwp -f srcs/wordpress/Dockerfile srcs/wordpress/
docker build -t mmysql -f srcs/mysql/Dockerfile srcs/mysql/
docker run -d --name wp -p 5050:5050 mwp
docker run -d --name mysql -p 3306:3306 mmysql
docker exec -ti mysql /bin/sh

