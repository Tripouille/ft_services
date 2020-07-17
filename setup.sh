#!/bin/zsh
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

#Checking minikube version
if [ $(minikube version | head -n 1 | cut -d ' ' -f 3) != "v1.12.0" ]
then
	echo "${GREEN}Upgrading minikube${NC}"
	sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
	sudo rm minikube-linux-amd64
fi

#Reset
sudo pkill nginx
sudo pkill mysql
docker rm -f $(docker ps -aq)
docker rmi $(docker images -aq)
minikube delete
rm -rf ~/.minikube

#Setup
sudo usermod -aG docker $USER
echo "${GREEN}Starting minikube:${NC}"
minikube start --vm-driver=docker

echo "${GREEN}Applying MetalLB:${NC}"
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

echo "${GREEN}Configuring MetalLB:${NC}"
IP=$(minikube ip | cut -d '.' -f 1-3)
LAST=$(minikube ip | cut -d '.' -f 4)
sed "s/IPADDRESSES/"$IP.$((LAST + 1))-$IP.254"/" srcs/metallb/configmap.yaml | \
kubectl create -f -

echo "${GREEN}Deploying services:${NC}"
eval $(minikube docker-env)

INFLUXDBIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/influxdb/influxdb.conf
echo "${GREEN}--> Creating influxdb server:${NC}"
echo "${GREEN}----> Building influxdb image:${NC}"
docker build -t myinfluxdb -f srcs/influxdb/Dockerfile srcs/influxdb/
echo "${GREEN}----> Applying  yaml:${NC}"
kubectl apply -f srcs/influxdb/influxdb.yaml

MYSQLIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/mysql/telegraf.conf
echo "${GREEN}--> Creating mysql server:${NC}"
echo "${GREEN}----> Building mysql image:${NC}"
docker build -t mymysql -f srcs/mysql/Dockerfile srcs/mysql/
echo "${GREEN}----> Applying mysql yaml:${NC}"
kubectl apply -f srcs/mysql/mysql.yaml

WPIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/wordpress/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$MYSQLIP/ srcs/wordpress/wp-config.php
echo "${GREEN}--> Creating wordpress server:${NC}"
echo "${GREEN}----> Building wordpress image:${NC}"
docker build -t mywordpress -f srcs/wordpress/Dockerfile srcs/wordpress/
echo "${GREEN}----> Applying wordpress yaml:${NC}"
kubectl apply -f srcs/wordpress/wordpress.yaml

PHPMYADMINIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/phpmyadmin/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$MYSQLIP/ srcs/phpmyadmin/config.inc.php
echo "${GREEN}--> Creating phpmyadmin server:${NC}"
echo "${GREEN}----> Building phpmyadmin image:${NC}"
docker build -t myphpmyadmin -f srcs/phpmyadmin/Dockerfile srcs/phpmyadmin/
echo "${GREEN}----> Applying phpmyadmin yaml:${NC}"
kubectl apply -f srcs/phpmyadmin/phpmyadmin.yaml

NGINXIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/nginx/telegraf.conf
echo "${GREEN}--> Creating nginx server:${NC}"
echo "${GREEN}----> Building nginx image:${NC}"
docker build -t mynginx -f srcs/nginx/Dockerfile srcs/nginx/
echo "${GREEN}----> Applying nginx yaml:${NC}"
kubectl apply -f srcs/nginx/nginx.yaml

FTPSIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/ftps/telegraf.conf
sed -ri s/"pasv_address=.*"/pasv_address=$FTPSIP/ srcs/ftps/vsftpd.conf
echo "${GREEN}--> Creating ftps server:${NC}"
echo "${GREEN}----> Building ftps image:${NC}"
docker build -t myftps -f srcs/ftps/Dockerfile srcs/ftps/
echo "${GREEN}----> Applying ftps yaml:${NC}"
kubectl apply -f srcs/ftps/ftps.yaml

GRAFANAIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/grafana/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/grafana/datasources.yml
echo "${GREEN}--> Creating grafana server:${NC}"
echo "${GREEN}----> Building grafana image:${NC}"
docker build -t mygrafana -f srcs/grafana/Dockerfile srcs/grafana/
echo "${GREEN}----> Applying  yaml:${NC}"
kubectl apply -f srcs/grafana/grafana.yaml

echo "${GREEN}Services Available:${NC}"
echo "${GREEN}INFLUXDB: ${YELLOW}$INFLUXDBIP:8086${NC}"
echo "${GREEN}MYSQL: ${YELLOW}$MYSQLIP:3306${NC}"
echo "${GREEN}WORDPRESS: ${YELLOW}$WPIP:5050${NC}"
echo "${GREEN}PHPMYADMIN: ${YELLOW}$PHPMYADMINIP:5000${NC}"
echo "${GREEN}NGINX: ${YELLOW}$NGINXIP:80${NC}"
echo "${GREEN}FTPS: ${YELLOW}$FTPSIP:21${NC}"
echo "${GREEN}GRAFANA: ${YELLOW}$GRAFANAIP:3000${NC}"
