#!/bin/sh

sudo apt-get update
sudo apt-get -y upgrade


# Clean Docker
sudo apt-get -y remove docker docker-engine docker.io containerd runc

# Install Docker
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --batch --yes --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin


# Add Grafana Image with TLS
mkdir grafana
cat << EOF > ./grafana/Dockerfile
FROM grafana/grafana:latest
USER root
RUN apk add openssl && \
    openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=Denial/L=Springfield/O=Dis/CN=localhost" \
    -keyout /etc/grafana/grafana.key  -out /etc/grafana/grafana.crt

RUN chown -R grafana:root /etc/grafana/grafana.crt && \
    chown -R grafana:root /etc/grafana/grafana.key && \
    chmod 400 /etc/grafana/grafana.key /etc/grafana/grafana.key
USER grafana
EOF

cat << EOF > docker-compose.yml
name: grafana
networks:
  grafana:

volumes:
  grafana_data: {}

services:

  grafana:
    build: ./grafana
    restart: unless-stopped
    ports:
      - 3000:3000
    networks:
      - grafana
    volumes:
      - grafana_data:/var/lib/grafana
    environment:
      - "GF_DEFAULT_APP_MODE=development"
      - "GF_LOG_LEVEL=debug"
      - "GF_SERVER_CERT_FILE=/etc/grafana/grafana.crt" # adjust to match your domain name
      - "GF_SERVER_CERT_KEY=/etc/grafana/grafana.key" # adjust to match your domain name
      - "GF_SERVER_PROTOCOL=https"
      - "GF_SECURITY_ADMIN_USER=admin"
      - "GF_SECURITY_ADMIN_PASSWORD=cloud2024"
EOF

sudo docker compose up -d --force-recreate grafana