#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "🔧 Installing essential CLI utilities..."

sudo apt-get update
sudo apt-get install -y jq htop fzf bat ripgrep tmux gh || true

# Lazygit installation fallback
if ! command -v lazygit &>/dev/null; then
  echo "⚠️ lazygit not found via apt — fetching latest release from GitHub..."
  LAZYGIT_TAG=$(curl -s https://api.github.com/repos/jesseduffield/lazygit/releases/latest | grep '"tag_name"' | cut -d '"' -f 4)
  LAZYGIT_VERSION="${LAZYGIT_TAG#v}"
  curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/${LAZYGIT_TAG}/lazygit_${LAZYGIT_VERSION}_Linux_x86_64.tar.gz"
  tar -xzf lazygit.tar.gz lazygit
  sudo install lazygit /usr/local/bin
  rm -f lazygit lazygit.tar.gz
else
  echo "✅ lazygit is already installed."
fi

echo "✅ CLI utilities installed."

echo "📦 Installing language managers and toolchains..."

# 🧠 Ensure ~/.local/bin is in PATH for tools like zoxide
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  echo "⚠️ ~/.local/bin is not in PATH — appending to current session and shell configs..."
  export PATH="$HOME/.local/bin:$PATH"
  grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
  grep -qxF 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.zshrc" || echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.zshrc"
fi

# 🛠 Backup ~/.asdf if pre-existing
if [[ -d "$HOME/.asdf" ]]; then
  backup_dir="$HOME/.asdf.backup.$(date +%s)"
  echo "⚠️ ~/.asdf directory already exists — backing up to $backup_dir"
  mv "$HOME/.asdf" "$backup_dir"
fi
