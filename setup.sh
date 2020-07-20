#!/bin/bash
#Checking minikube version
if [ $(minikube version | head -n 1 | cut -d ' ' -f 3) != "v1.12.0" ]
then
	echo "Upgrading minikube"
	sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
	sudo rm minikube-linux-amd64
fi

#Reset
docker rm -f $(docker ps -aq)
docker rmi $(docker images -aq)
minikube delete
rm -rf ~/.minikube

#Setup
sudo usermod -aG docker $USER
echo "Starting minikube:"
minikube start --vm-driver=docker
eval $(minikube docker-env)

#Config
echo "Applying MetalLB:"
kubectl get configmap kube-proxy -n kube-system -o yaml | \
sed -e "s/strictARP: false/strictARP: true/" | \
kubectl apply -f - -n kube-system
kubectl apply -f https://raw.githubusercontent.com/google/metallb/v0.8.1/manifests/metallb.yaml

echo "Configuring MetalLB:"
IP=$(minikube ip | cut -d '.' -f 1-3)
LAST=$(minikube ip | cut -d '.' -f 4)
sed "s/IPADDRESSES/"$IP.$((LAST + 1))-$IP.254"/" srcs/metallb/configmap.yaml | kubectl create -f -

echo "Deploying services:"
echo "--> Creating influxdb server:"
echo "----> Building influxdb image:"
docker build -t myinfluxdb -f srcs/influxdb/Dockerfile .
echo "----> Applying  yaml:"
kubectl apply -f srcs/influxdb/influxdb.yaml
INFLUXDBIP=$(kubectl get service | grep influxdb | tr -s ' ' | cut -d ' ' -f 3)

sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/mysql/telegraf.conf
echo "--> Creating mysql server:"
echo "----> Building mysql image:"
docker build -t mymysql -f srcs/mysql/Dockerfile .
echo "----> Applying mysql yaml:"
kubectl apply -f srcs/mysql/mysql.yaml
MYSQLIP=$(kubectl get service | grep mysql | tr -s ' ' | cut -d ' ' -f 3)

WPIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/wordpress/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$MYSQLIP/ srcs/wordpress/wp-config.php
echo "--> Creating wordpress server:"
echo "----> Building wordpress image:"
docker build -t mywordpress -f srcs/wordpress/Dockerfile .
echo "----> Applying wordpress yaml:"
kubectl apply -f srcs/wordpress/wordpress.yaml

PHPMYADMINIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/phpmyadmin/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$MYSQLIP/ srcs/phpmyadmin/config.inc.php
echo "--> Creating phpmyadmin server:"
echo "----> Building phpmyadmin image:"
docker build -t myphpmyadmin -f srcs/phpmyadmin/Dockerfile .
echo "----> Applying phpmyadmin yaml:"
kubectl apply -f srcs/phpmyadmin/phpmyadmin.yaml

NGINXIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/nginx/telegraf.conf
echo "--> Creating nginx server:"
echo "----> Building nginx image:"
docker build -t mynginx -f srcs/nginx/Dockerfile .
echo "----> Applying nginx yaml:"
kubectl apply -f srcs/nginx/nginx.yaml

FTPSIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/ftps/telegraf.conf
sed -ri s/"pasv_address=.*"/pasv_address=$FTPSIP/ srcs/ftps/vsftpd.conf
echo "--> Creating ftps server:"
echo "----> Building ftps image:"
docker build -t myftps -f srcs/ftps/Dockerfile .
echo "----> Applying ftps yaml:"
kubectl apply -f srcs/ftps/ftps.yaml

GRAFANAIP=$IP.$((++LAST))
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/grafana/telegraf.conf
sed -ri s/"([0-9]*\.){3}[0-9]*"/$INFLUXDBIP/ srcs/grafana/datasources.yml
echo "--> Creating grafana server:"
echo "----> Building grafana image:"
docker build -t mygrafana -f srcs/grafana/Dockerfile .
echo "----> Applying  yaml:"
kubectl apply -f srcs/grafana/grafana.yaml

echo "Services Available:"
echo "WORDPRESS: $WPIP:5050"
echo "PHPMYADMIN: $PHPMYADMINIP:5000"
echo "NGINX: $NGINXIP:80"
echo "FTPS: $FTPSIP:21"
echo "GRAFANA: $GRAFANAIP:3000"
