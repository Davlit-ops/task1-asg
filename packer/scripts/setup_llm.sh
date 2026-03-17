#!/bin/bash
set -e

echo "--- Installing Ollama ---"
curl -fsSL https://ollama.com/install.sh | sh

echo "--- Waiting for Ollama service to be ready ---"
until curl -s localhost:11434/api/tags > /dev/null; do
  echo "Waiting for Ollama API..."
  sleep 5
done

echo "--- Pulling TinyLlama model ---"
ollama pull tinyllama

echo "--- Pulling OpenWebUI Docker Image ---"
sudo docker pull ghcr.io/open-webui/open-webui:main

echo "--- LLM Setup Complete ---"
