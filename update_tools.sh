#!/usr/bin/env bash
set -e

echo "🔁 Updating tools and plugins..."

# Oh My Zsh
if [ -d "$HOME/.oh-my-zsh" ]; then
  echo "➡️ Updating Oh My Zsh..."
  git -C "$HOME/.oh-my-zsh" pull
fi

# Powerlevel10k
if [ -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
  echo "➡️ Updating Powerlevel10k..."
  git -C "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" pull
fi

# asdf and plugins
if command -v asdf &> /dev/null; then
  echo "➡️ Updating asdf..."
  asdf update
  echo "➡️ Updating asdf plugins..."
  asdf plugin update --all
fi

# System updates (Ubuntu/Debian)
if [ -f /etc/debian_version ]; then
  echo "➡️ Running apt updates..."
  sudo apt update && sudo apt upgrade -y
fi

# Scoop/Chocolatey on Windows (run from PowerShell)
if command -v scoop &> /dev/null; then
  echo "➡️ Updating Scoop packages..."
  scoop update *
elif command -v choco &> /dev/null; then
  echo "➡️ Updating Chocolatey packages..."
  choco upgrade all -y
fi
