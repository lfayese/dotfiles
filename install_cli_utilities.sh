#!/bin/bash
set -euo pipefail

echo "🔧 Installing essential CLI utilities..."

sudo apt-get update
sudo apt-get install -y jq htop fzf bat ripgrep tmux gh || true

# Handle lazygit install manually if not found in apt
if ! command -v lazygit &> /dev/null; then
  echo "⚠️ lazygit not found in apt — installing from GitHub releases..."
  LAZYGIT_TAG=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)
  LAZYGIT_VERSION=${LAZYGIT_TAG#v}
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_TAG}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -f lazygit lazygit.tar.gz
else
  echo "✅ lazygit is already installed."
fi

echo "✅ CLI utilities installed."
