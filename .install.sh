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
