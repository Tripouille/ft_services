#!/bin/bash
docker rm -f mc
docker rmi mi
docker build -t mi -f srcs/wordpress/Dockerfile srcs/wordpress/
docker run -d --name mc -p 5050:5050 mi
docker exec -ti mc /bin/sh