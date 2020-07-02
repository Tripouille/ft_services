GREEN='\033[0;32m'
NC='\033[0m'
#echo "Before sudo"
sudo usermod -aG docker $USER
#echo "After sudo"
#(newgrp docker)
echo "${GREEN}Starting minikube...${NC}"
minikube start --vm-driver=docker
echo "${GREEN}Applying MetalLB...${NC}"
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml
IP=$(minikube ip | cut -d '.' -f 1-3)
echo "${GREEN}Configuring MetalLB...${NC}"
sed "s/IPADDRESSES/"$IP.1-$IP.254"/" srcs/metallb/configmap_base.yaml > srcs/metallb/configmap.yaml
kubectl create -f srcs/metallb/configmap.yaml
echo "${GREEN}Creating nginx server...${NC}"
echo "${GREEN}Building nginx image...${NC}"
#PORT=$(minikube service --url nginx | cut -d ':' -f 3)
#sed s/PORT/$PORT/ srcs/nginx/default_base > srcs/nginx/default
docker build -t mynginx -f srcs/nginx/Dockerfile srcs/nginx/

kubectl apply -f srcs/nginx/nginx.yaml
kubectl expose deploy nginx --port 80 --type LoadBalancer
#kubectl create deploy nginx --image=mynginx
echo "${GREEN}Finished !${NC}"
