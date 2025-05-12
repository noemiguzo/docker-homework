# Docker Exercises Solution

---

## 🧪 Exercise 1: Build and Containerize an API (Back-End)

### 1️⃣ Develop the API in Python

Create a file named `app.py` with the following content:

```python
from flask import Flask, jsonify
import socket

app = Flask(__name__)

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

Also, create a `requirements.txt`:

```
flask
```

---

### 2️⃣ Dockerfile with Multistage Build

```Dockerfile
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
EXPOSE 5000
CMD ["python", "app.py"]
```

---

### 3️⃣ Build and Run the Backend Container

```bash
docker build -t simple-api .
docker run -d --name backend simple-api
```

Do **not** expose ports to the host to meet the requirement.

To test from the host, use:

```bash
docker exec -it backend curl http://localhost:5000/info
```

---

## 🖼️ Exercise 2: Build and Containerize a Front-End Application

### 1️⃣ Front-End Code (index.html)

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
        fetch('http://backend:5000/info')
            .then(response => response.json())
            .then(data => {
                document.getElementById('info').innerHTML = `
                    <p><strong>Hostname:</strong> ${data.hostname}</p>
                    <p><strong>IP Address:</strong> ${data.ip_address}</p>
                `;
            })
            .catch(error => {
                document.getElementById('info').innerHTML = 'Failed to fetch data';
                console.error('Error:', error);
            });
    </script>
</body>
</html>
```

---

### 2️⃣ Dockerfile for Front-End

```Dockerfile
FROM nginx:alpine AS final
COPY index.html /usr/share/nginx/html/index.html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

---

### 3️⃣Orquestación con Docker Compose
Crea docker-compose.yml 
```bash
version: '3.8'

services:
  backend:
    build:
      context: ./backend
      dockerfile: Dockerfile
    container_name: backend
    networks:
      - mynetwork

  frontend:
    build:
      context: ./frontend
      dockerfile: Dockerfile
    container_name: frontend
    ports:
      - "8080:80"
    networks:
      - mynetwork

networks:
  mynetwork:
    driver: bridge
```

Ambos servicios comparten la red mynetwork.

El frontend se expone en localhost:8080.
### 4 run backend and frontend con docker-compose.yml
---
```
docker-compose up -d --build
```

### ✅ Test in Browser

Go to:

```
http://localhost:8080
```