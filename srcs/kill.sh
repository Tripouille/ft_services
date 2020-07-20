echo "Service $1 / ps with $2:"
kubectl exec deploy/$1 -- ps | grep $2
echo "Killing $2"
kubectl exec deploy/$1 -- pkill $2
sleep 2
echo "Service $1 / ps $2:"
kubectl exec deploy/$1 -- ps