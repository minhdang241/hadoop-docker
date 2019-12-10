docker ps -a| grep datanode| awk '{system("docker rm " $1)}'
docker images| grep datanode| awk '{system("docker rmi " $1":"$2)}'

docker build -t datanode:0.1 .
