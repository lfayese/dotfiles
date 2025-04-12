#!/bin/bash
set -euo pipefail

REPO_URL="git@github.com:lfayese/dotfiles.git"
CLONE_DIR="$HOME/.dotfiles"

echo "📦 Cloning dotfiles repo into $CLONE_DIR..."
if [ -d "$CLONE_DIR" ]; then
  echo "⚠️ $CLONE_DIR already exists. Pulling latest changes..."
  cd "$CLONE_DIR"
  git pull
else
  git clone "$REPO_URL" "$CLONE_DIR"
  cd "$CLONE_DIR"
fi

echo "🚀 Running bootstrap..."
chmod +x bootstrap.sh
./bootstrap.sh


# --- Docker Daemon Check ---
echo "🐳 Checking Docker setup..."
if ! docker info &>/dev/null; then
  echo "⚠️ Docker daemon not accessible. Running fix_docker.sh..."
  chmod +x ./fix_docker.sh
  ./fix_docker.sh
else
  echo "✅ Docker daemon is accessible."
fi
