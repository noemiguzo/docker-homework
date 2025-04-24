#!/bin/bash
# Exercise 1
sudo apt update
sudo apt-get -y install ca-certificates
sudo apt-get update
sudo apt-get install -y ca-certificates curl
sudo install -m 0755 -d /etc/apt/keyrings
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc 
sudo chmod a+r /etc/apt/keyrings/docker.asc
echo   "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
  $(. /etc/os-release && echo "$VERSION_CODENAME") stable" |   sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
# sudo apt-get update
sudo apt-get install docker-ce
sudo docker info
sudo usermod -aG docker $USER
echo " Cierra y vuelve a iniciar sesión para aplicar los cambios del grupo 'docker'."
docker info

#  docker service
sudo systemctl enable docker
sudo systemctl status docker
sudo systemctl stop docker
sudo systemctl status docker
sudo systemctl start docker
sudo systemctl status docker

#   Exercise 2
sudo docker search --filter is-official=true Ubuntu
sudo docker search --filter is-official=true Alpine
sudo docker search --filter is-official=true Nginx 
sudo docker create nginx

sudo docker images
sudo docker container list -a
sudo docker start dazzling_jackson
sudo docker container list

#  Exercise 3 
systemctl status docker
systemctl stop docker
sudo systemctl stop docker.socket
docker run --name alpine0 alpine
systemctl start docker
docker run --name alpine0 alpine

#  Exercise 4
#docker run -it ubuntu
#apt update && apt install curl
#exit
#on one line
docker run --name ubuntu -it ubuntu bash -c "apt update && apt install -y curl && exit"
#  Exercise 5 
docker ps
docker ps -a

#  Exercise 6
# the "-d" argument to run a Docker container in the background
docker run -d --name nginx nginx
docker images
docker ps -a
docker container ls -a
docker pause nginx
docker container ls -a
docker unpause nginx
docker container ls -a
docker stop nginx
docker container ls -a
docker restart nginx
docker container ls -a
docker kill nginx
docker container ls -a

#  Exercise 7

docker container start nginx
docker container start ubuntu
docker container ls -a
docker container ls
docker rm -f ubuntu

docker stop nginx && docker rm nginx
docker container ls -a

#  Exercise 8 
docker pull alpine
docker pull ubuntu

docker container ls

#  Exercise 9 
docker run --name alpine alpine
docker images
docker run --name alpine2 alpine echo "hello from alpine" && uname -a
docker ps -a

#  Exercise 10
docker container ls -a
docker rm $(docker ps -a -q -f status=exited)
 
docker container prune -f
docker container ls -a
# have more images
docker run --name docker-nginx -p 80:80 -d nginx
docker start docker-nginx
docker run --name alpine0 alpine

docker image prune -a
docker container prune
docker container ls -a


docker system df
docker ps -s
docker history nginx



 