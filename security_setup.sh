#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "🔐 Configuring security (SSH + GPG)..."

# SSH setup
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f ~/.ssh/id_ed25519 -N ""
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  gh auth login
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)-auto"
fi

# Add ~/.local/bin to PATH if zoxide installed there
if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' ~/.zshrc; then
  echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
fi

# GPG keygen (RSA fallback)
cat <<EOF | gpg --batch --gen-key
Key-Type: RSA
Key-Length: 4096
Name-Real: Laolu Fayese
Name-Email: 166741136+lfayese@users.noreply.github.com
Expire-Date: 1y
%no-protection
%commit
EOF

echo "✅ SSH and GPG setup complete."
