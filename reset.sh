docker rm -f $(docker ps -aq)
docker rmi $(docker images -aq)
minikube delete
rm -rf ~/.minikube
