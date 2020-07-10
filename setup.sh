#!/bin/zsh
GREEN='\033[0;32m'
NC='\033[0m'

#Reset
sudo pkill nginx
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

ACTUALSERVICES=1
echo "${GREEN}Deploying services:${NC}"
eval $(minikube docker-env)

NGINXIP=$IP.$((LAST + ACTUALSERVICES++))
echo "${GREEN}--> Creating nginx server:${NC}"
echo "${GREEN}----> Building nginx image:${NC}"
docker build -t mynginx -f srcs/nginx/Dockerfile srcs/nginx/
echo "${GREEN}----> Applying nginx yaml:${NC}"
kubectl apply -f srcs/nginx/nginx.yaml
echo "${GREEN}Succes service ip = $NGINXIP:${NC}"

FTPSIP=$IP.$((LAST + ACTUALSERVICES++))
sed -ri s/"pasv_address=.*"/pasv_address=$FTPSIP/ srcs/ftps/vsftpd.conf
echo "${GREEN}--> Creating ftps server:${NC}"
echo "${GREEN}----> Building ftps image:${NC}"
docker build -t myftps -f srcs/ftps/Dockerfile srcs/ftps/
echo "${GREEN}----> Applying ftps yaml:${NC}"
kubectl apply -f srcs/ftps/ftps.yaml
echo "${GREEN}Succes service ip = $FTPSIP:${NC}"

MYSQLIP=$IP.$((LAST + ACTUALSERVICES++))
echo "${GREEN}--> Creating mysql server:${NC}"
echo "${GREEN}----> Building mysql image:${NC}"
docker build -t mymysql -f srcs/mysql/Dockerfile srcs/mysql/
echo "${GREEN}----> Applying mysql yaml:${NC}"
kubectl apply -f srcs/mysql/mysql.yaml
echo "${GREEN}Succes service ip = $MYSQLIP:${NC}"

WPIP=$IP.$((LAST + ACTUALSERVICES++))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$MYSQLIP/ srcs/wordpress/wp-config.php
echo "${GREEN}--> Creating wordpress server:${NC}"
echo "${GREEN}----> Building wordpress image:${NC}"
docker build -t mywordpress -f srcs/wordpress/Dockerfile srcs/wordpress/
echo "${GREEN}----> Applying wordpress yaml:${NC}"
kubectl apply -f srcs/wordpress/wordpress.yaml
echo "${GREEN}Succes service ip = $WPIP:${NC}"

echo "${GREEN}Finished !${NC}"
echo "${GREEN}NGINX: $NGINXIP !${NC}"
echo "${GREEN}FTPS: $FTPSIP !${NC}"
echo "${GREEN}MYSQL: $MYSQLIP !${NC}"
echo "${GREEN}WORDPRESS: $WPIP !${NC}"
