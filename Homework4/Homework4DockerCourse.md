# Exercise 1: Deploy Back End and Front End with Docker Compose

## Deploy Back End and Front End with Docker Compose.

Deploy two services (`api` and `fe`) using Docker Compose with the following specifications:

1. Create a compose.yml file.
2. Define two services: api and fe , using the private registry images:
docker.jaja.pro/docker-training/backend:[TAG]
docker.jaja.pro/docker-training/frontend:[TAG]]
3. Use a user-defined bridge network to allow inter-container communication.
4. Use volumes to persist data of each service.

---

## Step 1: Create `compose.yml`

Create a file named `compose.yml` with the following content:

```yaml
version: '3.8'

services:
  api:
    image: docker.jala.pro/docker-training/backend:calebespinoza
    container_name: backend
    networks:
      - mynetwork
    volumes:
      - api-data:/app
  fe:
    image: docker.jala.pro/docker-training/frontend:calebespinoza
    container_name: frontend
    ports:
      - "8080:80"
    networks:
      - mynetwork
      - mynetwork
    volumes:
      - fe-data:/usr/share/nginx/html
networks:
  mynetwork:
    driver: bridge
volumes:
  api-data:
  fe-data:    
```



## Step 2: Login to Private Registry (if required)

```bash
docker login docker.jala.pro
```

Enter  username and password when prompted.

---

## Step 3: Deploy the Application

Run the following:

```bash
docker compose -f compose.yml up -d
```

---

## Step 4: Verify Everything is Working

1. Check that containers are running:

```bash
docker ps
```

2. Open your browser and go to:  
   [http://localhost:8080](http://localhost:8080)
[ip of ubuntu instance]
You should see the frontend application fetching data from the backend `/info` endpoint.

---
