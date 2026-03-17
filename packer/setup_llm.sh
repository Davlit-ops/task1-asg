#!/bin/bash

set -e

echo "--- Updating System and Installing Dependencies ---"
sudo apt-get update
# For compiling Python packages
sudo apt-get install -y python3-pip python3-venv python3-dev build-essential curl libpq-dev

echo "--- Installing Ollama ---"
curl -fsSL https://ollama.com/install.sh | sh

# Wait 
echo "--- Waiting for Ollama service to be ready ---"
until curl -s localhost:11434/api/tags > /dev/null; do
  echo "Waiting for Ollama API..."
  sleep 5
done

echo "--- Pulling TinyLlama model ---"
ollama pull tinyllama

echo "--- Setting up OpenWebUI ---"
sudo mkdir -p /opt/open-webui
sudo chown ubuntu:ubuntu /opt/open-webui
cd /opt/open-webui

# Python Virtual Environment
python3 -m venv venv
source venv/bin/activate

# Into the virtual environment
pip install --upgrade pip
pip install open-webui
pip install psycopg2-binary

echo "--- Configuring Systemd Service ---"
# From the temporary directory to the correct system location
sudo mv /tmp/open-webui.service /etc/systemd/system/open-webui.service

# Set permissions
sudo chown root:root /etc/systemd/system/open-webui.service
sudo chmod 644 /etc/systemd/system/open-webui.service

# Reloading systemd and enabling the service
sudo systemctl daemon-reload
sudo systemctl enable open-webui

echo "--- LLM Setup Complete ---"
