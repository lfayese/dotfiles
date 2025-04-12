#!/bin/bash
set -euo pipefail

echo "🐳 Docker Daemon Diagnostics & Fix Tool"

# Check if docker is installed
if ! command -v docker &> /dev/null; then
  echo "❌ Docker is not installed. Please install Docker Desktop or Engine first."
  exit 1
fi

echo "✅ Docker CLI is installed."

# Check Docker daemon status
echo "🔍 Checking Docker daemon accessibility..."
if docker info &> /dev/null; then
  echo "✅ Docker daemon is running and accessible."
  exit 0
fi

echo "⚠️ Docker daemon is not accessible."

# Try systemctl start (for Linux distros using systemd)
if command -v systemctl &> /dev/null; then
  echo "⏳ Attempting to start Docker using systemctl..."
  sudo systemctl start docker
  sleep 3
  if docker info &> /dev/null; then
    echo "✅ Docker started successfully using systemctl."
    exit 0
  fi
fi

# Try restarting Docker Desktop (WSL case)
if grep -i microsoft /proc/version &> /dev/null; then
  echo "⚙️ Detected WSL environment. Trying WSL restart..."
  powershell.exe -Command "wsl --shutdown"
  echo "🔁 Please manually restart Docker Desktop from Windows UI."
  exit 1
fi

# Manual fallback
echo "❌ Failed to automatically start Docker."
echo "👉 Please try starting Docker manually:"
echo "   sudo systemctl start docker   # for Linux"
echo "   OR use Docker Desktop UI on Windows/Mac"
exit 1
