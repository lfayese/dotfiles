#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "📦 Installing language managers and toolchains..."

# Install asdf and plugin dependencies
git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.bashrc
echo '. "$HOME/.asdf/asdf.sh"' >> ~/.zshrc

# Add some common plugins
~/.asdf/bin/asdf plugin-add nodejs || true
~/.asdf/bin/asdf plugin-add python || true
~/.asdf/bin/asdf plugin-add ruby || true

sudo apt-get install -y build-essential gcc g++ gdb lldb

echo "✅ Language managers and toolchains installed."
