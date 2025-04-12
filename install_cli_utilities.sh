#!/bin/bash
set -euo pipefail

echo "🔧 Installing essential CLI utilities..."

sudo apt-get update
sudo apt-get install -y jq htop fzf bat ripgrep tmux gh lazygit

echo "✅ CLI utilities installed."
