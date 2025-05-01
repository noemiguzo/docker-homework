Homework 2 - Docker Extended Topics

Exercise 1: Docker Networks
---------------------------
1. List all Docker networks:
```bash
docker network ls
```

2. Inspect the default 'bridge' network:
```bash
docker network inspect bridge
```

3. Create a new user-defined bridge network:
```bash
docker network create --driver bridge my_custom_network
```

4. Run a container attached to the network and inspect its IP:
```bash
docker run -dit --name my_test_container --network my_custom_network alpine
```
```bash
docker inspect -f '{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}' my_test_container
```


Exercise 2: Container Communication
-----------------------------------
1. Run two Nginx containers connected to the user-defined network:
```bash
docker run -dit --name nginx1 --network my_custom_network nginx
```
```bash
docker run -dit --name nginx2 --network my_custom_network nginx
```

2. Ping between containers using container names:
```bash
docker exec -it nginx1 /bin/sh
```
```bash
ping nginx2
```


Exercise 3: Docker Volumes
--------------------------
1. Create a Docker volume:
```bash
docker volume create my_data_volume
```

2. Run a container using the volume:
```bash
docker run -dit --name vol_container -v my_data_volume:/data alpine
```

3. Write a file in the volume:
```bash
docker exec -it vol_container sh -c "echo 'Persistent data' > /data/hello.txt"
```

4. Stop and restart the container, verify file:
```bash
docker stop vol_container
```
```bash
docker start vol_container
```
```bash
docker exec -it vol_container sh -c "cat /data/hello.txt"
```


Exercise 4: Bind Mounts
-----------------------
1. Create directory on host:
```bash
mkdir -p ~/docker_bind_test
```

2. Run container with bind mount:
```bash
docker run -dit --name bind_container -v ~/docker_bind_test:/mnt alpine
```

3. Create a file in /mnt from container:
```bash
docker exec -it bind_container sh -c "echo 'Hello from container' > /mnt/testfile.txt"
```
```bash
cat ~/docker_bind_test/testfile.txt
```


Exercise 5: Compare Volume and Bind Mount
-----------------------------------------
1. Create a file in a named volume:
```bash
docker volume create vol_demo_01
```
```bash
docker run -dit --name vol_container_01 -v vol_demo_01:/app_data alpine
```
```bash
docker exec -it vol_container_01 sh -c "echo 'Contenido del volumen' > /app_data/archivo_vol.txt"
```

2. Create a file using a bind mount:
```bash
mkdir -p ~/bind_demo_01
```
```bash
docker run -dit --name bind_container_01 -v ~/bind_demo_01:/mnt alpine
```
```bash
docker exec -it bind_container_01 sh -c "echo 'Contenido del bind mount' > /mnt/archivo_bind.txt"
```

3. Observe where data is stored on the host with docker volume inspect and ls .
```bash
docker volume inspect vol_demo_01
```
```bash
sudo ls /var/lib/docker/volumes/vol_demo_01/_data
   ls ~/bind_demo_01
```


Exercise 6: Docker in Docker (DinD)
-----------------------------------
1. Run Ubuntu container with Docker access:
```bash
docker run -dit --name dind_ubuntu -v /var/run/docker.sock:/var/run/docker.sock ubuntu
```

2. Exec and install Docker CLI:
```bash
docker exec -it dind_ubuntu bash
```
```bash
apt update && apt install -y docker.io
```
```bash
docker version
```


Exercise 7: Resource Limits
---------------------------
1. Run container with memory and CPU limits:
```bash
docker run -dit --name limited_container --memory=256m --cpus=0.5 alpine
```
```bash
docker run -d --name my_container --memory=256m --cpus=0.5 nginx
```

2. Check resource usage:
```bash
docker stats limited_container
```

3. Check disk usage:
```bash
docker system df
```

Exercise 8:
--------------------------

1. Run a container with policy –restart on-failure:    
```bash
docker run -d --name my_container --restart on-failure nginx
```
2. Kill the container and observe how it restarts:
```bash
docker kill my_container
```
3. Try with the policy —restart unless-stopped:   
```bash
docker run -d --name my_container --restart unless-stopped nginx
```
4. Reboot the system and see what happens:    
```bash
sudo reboot
```

Exercise 9
--------------------------      
1. Create a network: 
```bash
docker network create my_custom_net
```
 
2. Create a volume:
```bash
docker volume create mariadb_data
```
     
3. Run a MariaDB container with the following requirements:
    - Attached to volume.
    - Attached to network.
    - Do NOT expose ANY port.
```bash
docker run -dit --name my_mariadb --network my_custom_net --mount source=mariadb_data,target=/var/lib/mysql -e MARIADB_ROOT_PASSWORD=my-secret-pw mariadb
```
       
Exercise 10:
--------------------------
1. Run a PHPMyAdmin container with the following requirements:
    - Attached to network (created in Exercise 9).
    - Use a bind mount to persist the web app configuration.
    - Linked to the previous MariaDB container (created in Exercise 9).
    - Open a browser to display the PHPMyAdmin Login Form.    
```bash
docker run -dit --name my_phpmyadmin --network my_custom_net --mount type=bind,source=$HOME/phpmyadmin_config,target=/etc/phpmyadmin -e PMA_HOST=my_mariadb -e PMA_PORT=3306 -e PMA_USER=root -e PMA_PASSWORD=my-secret-pw -p 8081:80 phpmyadmin
```
        
2. Login with the DB credentials.  