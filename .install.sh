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


# --- Auto-install required packages ---
echo "📦 Checking and installing required dependencies..."
DEPS=(git curl gpg docker)

for pkg in "${DEPS[@]}"; do
  if ! command -v $pkg &>/dev/null; then
    echo "📥 Installing missing: $pkg"
    if [ -f /etc/debian_version ]; then
      sudo apt-get update && sudo apt-get install -y $pkg
    elif [ -f /etc/redhat-release ]; then
      sudo yum install -y $pkg
    elif [ -f /etc/arch-release ]; then
      sudo pacman -Sy --noconfirm $pkg
    else
      echo "⚠️ Please install $pkg manually for your distro."
    fi
  else
    echo "✅ $pkg is already installed"
  fi
done
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
