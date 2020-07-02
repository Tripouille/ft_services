docker image rm -f mi
docker build -t mi .
docker rm -f mc
docker run --name mc -d -p 80:80 -p 443:443 mi
docker exec -ti mc sh