#!/bin/bash
set -euo pipefail

echo "🔐 Configuring security (SSH + GPG)..."

# SSH key setup
if [ ! -f ~/.ssh/id_ed25519 ]; then
  ssh-keygen -t ed25519 -C "$USER@$(hostname)" -f ~/.ssh/id_ed25519 -N ""
  eval "$(ssh-agent -s)"
  ssh-add ~/.ssh/id_ed25519
  gh auth login
  gh ssh-key add ~/.ssh/id_ed25519.pub --title "$(hostname)-auto"
fi

# GPG key setup
gpg --batch --gen-key <<EOF
%no-protection
Key-Type: default
Subkey-Type: default
Name-Real: Dev Toolkit
Name-Email: devtoolkit@example.com
Expire-Date: 1y
%commit
EOF

echo "✅ SSH and GPG setup complete."
