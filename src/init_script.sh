#!/bin/bash

sudo apt-get update
sudo apt-get -y upgrade

# Install awscli
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install


# Clean Docker
sudo apt-get -y remove docker docker-engine docker.io containerd runc

# Install Docker
sudo apt-get -y install ca-certificates curl gnupg lsb-release
sudo mkdir -m 0755 -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update

sudo apt-get -y install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Get repo with grafana

git clone https://github.com/TheMatrix97/tutorial-environment && cd tutorial-environment

# Update passw to Cloud2024
sed -i 's/GF_SECURITY_ADMIN_PASSWORD=cloud2023/GF_SECURITY_ADMIN_PASSWORD=cloud2024/' docker-compose.yml

sudo docker compose up -d --force-recreate grafana