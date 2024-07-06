#!/bin/sh

# Add Grafana source apt
sudo apt update && sudo apt-get install -y apt-transport-https software-properties-common wget unzip
sudo mkdir -p /etc/apt/keyrings/
wget -q -O - https://apt.grafana.com/gpg.key | gpg --dearmor | sudo tee /etc/apt/keyrings/grafana.gpg > /dev/null
echo "deb [signed-by=/etc/apt/keyrings/grafana.gpg] https://apt.grafana.com stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
sudo apt-get update

# Installs the latest OSS release:
sudo apt-get -y install grafana

# Set Admin password cloud2024
sudo grafana-cli admin reset-admin-password cloud2024

sudo systemctl daemon-reload && sudo systemctl enable grafana-server --now