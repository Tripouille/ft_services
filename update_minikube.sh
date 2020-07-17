if [ $(minikube version | head -n 1 | cut -d ' ' -f 3) != "v1.12.0" ]
then
	echo "Upgrading minikube version to v1.12.0"
	sudo curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube-linux-amd64
	sudo install minikube-linux-amd64 /usr/local/bin/minikube
fi