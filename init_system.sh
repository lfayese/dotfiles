#!/bin/bash
set -euo pipefail

echo "🧰 Initializing system and installing base packages..."

# Suppress ldconfig warning about CUDA in WSL
sudo ldconfig 2>/dev/null || true

# Update system
sudo apt update -y && sudo apt upgrade -y

# Install critical base tools first
sudo apt install -y \
  curl \
  wget \
  unzip \
  gnupg \
  lsb-release \
  software-properties-common \
  ca-certificates \
  apt-transport-https
