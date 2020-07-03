#!/bin/sh
GREEN='\033[0;32m'
NC='\033[0m'
#Reset
docker rm -f $(docker ps -aq)
#docker rmi $(docker images -aq)
minikube delete
rm -rf ~/.minikube
#Setup
sudo usermod -aG docker $USER
echo "${GREEN}Starting minikube ...${NC}"
minikube start --vm-driver=docker

echo "${GREEN}Applying MetalLB ...${NC}"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
echo "${GREEN}Configuring MetalLB ...${NC}"
IP=$(minikube ip | cut -d '.' -f 1-3)
sed "s/IPADDRESSES/"$IP.1-$IP.254"/" srcs/metallb/configmap_base.yaml > srcs/metallb/configmap.yaml
kubectl create -f srcs/metallb/configmap.yaml

echo "${GREEN}Deploying service ...${NC}"
eval $(minikube docker-env)

echo "${GREEN}Creating nginx server ...${NC}"
echo "${GREEN}Building nginx image ...${NC}"
docker build -t mynginx -f srcs/nginx/Dockerfile srcs/nginx/
echo "${GREEN}Applying nginx yaml ...${NC}"
kubectl apply -f srcs/nginx/nginx.yaml
echo "${GREEN}Finished !${NC}"
