#!/bin/bash

set -euo pipefail

echo "🔗 Creating symlinks for dotfiles..."

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
mkdir -p "$HOME/.vscode"
mkdir -p "$HOME/.docker"

# Symlink VSCode settings
if [[ -f "$DOTFILES_DIR/.vscode/settings.json" ]]; then
  ln -sf "$DOTFILES_DIR/.vscode/settings.json" "$HOME/.vscode/settings.json"
  echo "✅ Linked VSCode settings"
else
  echo "⚠️ Missing: .vscode/settings.json"
fi

# Symlink Docker config
if [[ -f "$DOTFILES_DIR/.docker/config.json" ]]; then
  ln -sf "$DOTFILES_DIR/.docker/config.json" "$HOME/.docker/config.json"
  echo "✅ Linked Docker config"
else
  echo "⚠️ Missing: .docker/config.json"
fi

echo "🏁 Done creating symlinks."
