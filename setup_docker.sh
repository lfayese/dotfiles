#!/bin/bash

echo "🐳 Verifying Docker setup for WSL2..."

# Check if Docker CLI is available
if ! command -v docker &>/dev/null; then
    echo "❌ Docker CLI not found. Please install Docker Desktop and ensure WSL integration is enabled."
    exit 1
fi

echo "✅ Docker CLI is available."

# Check if Docker daemon is running
if ! docker info &>/dev/null; then
    echo "⚠️ Docker daemon not accessible."
    echo "👉 Make sure Docker Desktop is running and WSL integration is enabled for this distro."
    echo "   Try launching Docker Desktop manually or run: 'wsl --shutdown' and restart Docker."
    exit 1
fi

echo "✅ Docker daemon is accessible."

# Check if current user is in docker group
if groups | grep -qv '\bdocker\b'; then
    echo "⚠️ Current user is not in the 'docker' group."
    echo "👉 You may need to run: sudo usermod -aG docker $USER && newgrp docker"
fi

# Run a simple test container
echo "🚀 Running a test container..."
docker run --rm hello-world

echo "🎉 Docker is fully operational!"