# Solución de Ejercicios Homework3 - Docker course

---

## 🧪 Exercise 1: Build and Containerize an API (Back-End)

### 1. Estructura en `backend/`
```
backend/
├── app.py
├── requirements.txt
└── Dockerfile
```

### 2. Código del API (`backend/app.py`)
```python
from flask import Flask, jsonify
from flask_cors import CORS
import socket

app = Flask(__name__)
CORS(app)

@app.route('/info')
def info():
    hostname = socket.gethostname()
    ip_address = socket.gethostbyname(hostname)
    return jsonify({
        'hostname': hostname,
        'ip_address': ip_address
    })

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
```

### 3. Dependencias (`backend/requirements.txt`)
```
flask
flask-cors
```

### 4. Dockerfile (`backend/Dockerfile`)
```dockerfile
# Stage 1: Build
FROM python:3.11-slim AS builder
WORKDIR /app
COPY requirements.txt .
RUN pip install --user -r requirements.txt

# Stage 2: Runtime
FROM python:3.11-slim
WORKDIR /app
COPY --from=builder /root/.local /root/.local
ENV PATH=/root/.local/bin:$PATH
COPY app.py .
CMD ["python", "app.py"]
```

### 5. Crear red Docker
```bash
docker network create mynetwork
```

### 6. Construir y ejecutar el Backend
```bash

docker build -t simple-api ./backend
docker run -d \
  --name backend \
  --network mynetwork \
  simple-api
```

---

## 🖼️ Exercise 2: Build and Containerize a Front-End Application

### 1. Estructura en `frontend/`
```
frontend/
├── index.html
├── nginx.conf
└── Dockerfile
```

### 2. Archivo HTML (`frontend/index.html`)
```html
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>Container Info</title>
</head>
<body>
  <h1>Container Info</h1>
  <div id="info">Loading...</div>
  <script>
    fetch('/info')
      .then(response => response.json())
      .then(data => {
        document.getElementById('info').innerHTML = `
          <p><strong>Hostname:</strong> ${data.hostname}</p>
          <p><strong>IP Address:</strong> ${data.ip_address}</p>
        `;
      })
      .catch(err => {
        document.getElementById('info').textContent = 'Failed to fetch data';
        console.error(err);
      });
  </script>
</body>
</html>
```

### 3. Configuración de Nginx (`frontend/nginx.conf`)
```nginx
events { }
http {
  server {
    listen 80;
    location / {
      root /usr/share/nginx/html;
      index index.html;
      try_files $uri $uri/ =404;
    }
    location /info {
      proxy_pass http://backend:5000/info;
    }
  }
}
```

### 4. Dockerfile (`frontend/Dockerfile`)
```dockerfile
FROM nginx:alpine
WORKDIR /usr/share/nginx/html
COPY nginx.conf /etc/nginx/nginx.conf
COPY index.html .
CMD ["nginx", "-g", "daemon off;"]
```

### 5. Construir y ejecutar el Frontend
```bash

docker build -t frontend-image ./frontend
docker run -d \
  --name frontend \
  --network mynetwork \
  -p 8080:80 \
  frontend-image
```

---

## ✅ Verificación Final

1. Abre el navegador en `http://localhost:8080`. or  http://127.0.0.1:8080/info

2. Debera ver el **hostname** y la **IP** del contenedor backend.
```bash
ubuntu@k8s-instance-6:~$ curl "http://127.0.0.1:8080/info"
{"hostname":"7ecc8f714f1b","ip_address":"172.19.0.2"}
```
#Exercise 3: The	.dockerignore File
backend/.dockerignore
```bash
# Sistema y metadatos
.git
.gitignore
# Archivos Python compilados
__pycache__/
*$py.class
# Entornos virtuales
venv/
env/
.env
# Docker
Dockerfile*
docker-compose.yml
```
frontend/.dockerignore
```bash
# Sistema y metadatos
.git
.gitignore

# Dependencias y builds locales
build/
# Archivos de configuración local
.env
.vscode/
.idea/
# Logs
*.log
# Docker
docker-compose.yml
```

# Exercise 4: Push Images to Private Registry
  imágenes:
- **Back End**: `simple-api`
- **Front End**: `frontend-image`

---

## 1. Login al registry privado

```bash
docker login docker.jala.pro
```

---

## 2. Etiquetar (tag) las imágenes

Usaremos el formato:
```
docker.jala.pro/docker-training/[container-name]:[tag]
```

### Back End
```bash
docker tag simple-api \
  docker.jala.pro/docker-training/backend:calebespinoza
```

### Front End
```bash
docker tag frontend-image \
  docker.jala.pro/docker-training/frontend:calebespinoza
```


---

## 3. Push de las imágenes al registry

### Back End
```bash
docker push docker.jala.pro/docker-training/backend:calebespinoza
```

### Front End
```bash
docker push docker.jala.pro/docker-training/frontend:calebespinoza
```

---

## 4. Verificar

Puedes hacer pull las imágenes :

```bash
docker pull docker.jala.pro/docker-training/backend:calebespinoza
docker pull docker.jala.pro/docker-training/frontend:calebespinoza
```
List imagenes
```bash
ubuntu@k8s-instance-6:~$ docker images
REPOSITORY                                 TAG             IMAGE ID       CREATED        SIZE
frontend-image                             latest          9466c36190a8   2 hours ago    48.2MB
docker.jala.pro/docker-training/frontend   calebespinoza   9466c36190a8   2 hours ago    48.2MB
simple-api                                 latest          55806b7018a8   2 hours ago    135MB
docker.jala.pro/docker-training/backend    calebespinoza   55806b7018a8   2 hours ago    135MB
```