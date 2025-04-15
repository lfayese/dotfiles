#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"
echo "📦 Installing Youki and gVisor container runtimes"

# Install youki (Rust required)
if ! command -v youki &>/dev/null; then
  echo "🚧 Installing youki..."
  sudo apt-get update
  sudo apt-get install -y build-essential libseccomp-dev pkg-config libclang-dev
  
  # Check if Rust/Cargo is installed
  if ! command -v cargo &>/dev/null; then
    echo "⚠️ Rust/Cargo not found. Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi
  
  cargo install youki || { 
    echo "⚠️ Youki install via cargo failed. Attempting binary download..."
    YOUKI_VERSION="0.0.1"  # Update this version as needed
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    wget "https://github.com/containers/youki/releases/download/v${YOUKI_VERSION}/youki_$(uname -m).tar.gz" -O youki.tar.gz || {
      echo "❌ Failed to download youki binary. Please install manually."
      cd - >/dev/null
      rm -rf "$TEMP_DIR"
      exit 1
    }
    tar -xzf youki.tar.gz
    chmod +x youki
    sudo mv youki /usr/local/bin/
    cd - >/dev/null
    rm -rf "$TEMP_DIR"
  }
  
  # Make sure youki is in /usr/local/bin regardless of how it was installed
  if [ -f ~/.cargo/bin/youki ] && [ ! -f /usr/local/bin/youki ]; then
    sudo cp ~/.cargo/bin/youki /usr/local/bin/youki
    sudo chmod +x /usr/local/bin/youki
  fi
fi

# Install gVisor
if ! command -v runsc &>/dev/null; then
  echo "🚧 Installing gVisor..."
  wget https://storage.googleapis.com/gvisor/releases/release/latest/runsc -O runsc
  chmod +x runsc && sudo mv runsc /usr/local/bin/
  sudo mkdir -p /etc/containerd
  cat <<EOF | sudo tee /etc/containerd/runsc.toml
[plugins."io.containerd.runtime.v1.linux"]
  shim = "containerd-shim-runsc-v1"
EOF
fi

echo "✅ Youki and gVisor runtimes installed"
