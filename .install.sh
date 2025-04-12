#!/bin/bash
set -euo pipefail

REPO_URL="git@github.com:lfayese/dotfiles.git"
CLONE_DIR="$HOME/.dotfiles"

echo "📦 Cloning dotfiles repo into $CLONE_DIR..."
if [ -d "$CLONE_DIR" ]; then
  echo "⚠️ $CLONE_DIR already exists. Pulling latest changes..."
  cd "$CLONE_DIR"

# Auto-update if this is a git repo
if [ -d .git ]; then
  echo "🔄 Pulling latest updates from GitHub..."
  make update || echo "⚠️ Could not update from origin"
fi
  git pull
else
  git clone "$REPO_URL" "$CLONE_DIR"
  cd "$CLONE_DIR"

# Auto-update if this is a git repo
if [ -d .git ]; then
  echo "🔄 Pulling latest updates from GitHub..."
  make update || echo "⚠️ Could not update from origin"
fi
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

# --- Detect Distro ---
echo "🔎 Detecting distribution..."
if [ -f /etc/os-release ]; then
  . /etc/os-release
  echo "✅ Detected: $NAME $VERSION"
elif command -v lsb_release &> /dev/null; then
  lsb_release -a
else
  echo "⚠️ Unable to determine OS distribution."
fi

# --- Run test_env.sh ---
echo "🧪 Running environment validation..."
chmod +x ./test_env.sh
./test_env.sh
