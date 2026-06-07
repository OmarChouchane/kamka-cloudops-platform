#!/usr/bin/env bash
set -euo pipefail

# Install Docker
curl -fsSL https://get.docker.com | sh
sudo usermod -aG docker "$USER"

# Install Docker Compose plugin
sudo apt-get install -y docker-compose-plugin

# Create app directory
sudo mkdir -p /opt/kamka
sudo chown "$USER":"$USER" /opt/kamka

echo "Bootstrap complete. Re-login for docker group to take effect."
