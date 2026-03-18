#!/bin/bash

set -euo pipefail

# skip Do you want to continue?
export DEBIAN_FRONTEND=noninteractive

echo "--- [1/6] Updating System and Installing Dependencies ---"
sudo apt-get update -y
# For compiling Python packages
sudo apt-get install -y python3-pip python3-venv python3-dev build-essential curl libpq-dev

echo "--- [2/6] Installing Ollama ---"
curl -fsSL https://ollama.com/install.sh | sh

# Wait 
echo "--- [3/6] Waiting for Ollama service to be ready ---"
# Prevent infinite loop
MAX_RETRIES=12
RETRY_COUNT=0
until curl -s http://localhost:11434/api/tags > /dev/null; do
  if [ ${RETRY_COUNT} -ge ${MAX_RETRIES} ]; then
    echo "Error: Ollama API did not start in time."
    exit 1
  fi
  echo "Waiting for Ollama API (Attempt $((RETRY_COUNT+1))/${MAX_RETRIES})..."
  sleep 5
  RETRY_COUNT=$((RETRY_COUNT+1))
done

echo "--- [4/6] Pulling TinyLlama model ---"
ollama pull tinyllama

echo "--- [5/6] Setting up OpenWebUI ---"
sudo mkdir -p /opt/open-webui
sudo chown ubuntu:ubuntu /opt/open-webui
sudo chmod 750 /opt/open-webui
cd /opt/open-webui

# Python Virtual Environment
python3 -m venv venv
source venv/bin/activate

# Into the virtual environment
pip install --no-cache-dir --upgrade pip
pip install --no-cache-dir open-webui psycopg2-binary

echo "--- [6/6] Configuring Systemd Service ---"
# From the temporary directory to the correct system location
sudo mv /tmp/open-webui.service /etc/systemd/system/open-webui.service

# Set permissions
sudo chown root:root /etc/systemd/system/open-webui.service
sudo chmod 644 /etc/systemd/system/open-webui.service

# Reloading systemd and enabling the service
sudo systemctl daemon-reload
sudo systemctl enable open-webui

echo "--- LLM Setup Complete ---"
