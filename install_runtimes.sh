#!/bin/bash
set -euo pipefail
echo "📦 Installing Youki and gVisor container runtimes"

# Install youki (Rust required)
if ! command -v youki &>/dev/null; then
  echo "🚧 Installing youki..."
  sudo apt-get update
  sudo apt-get install -y build-essential libseccomp-dev pkg-config libclang-dev
  cargo install youki || { echo "⚠️ Youki install via cargo failed. Manual install needed."; }
  sudo cp ~/.cargo/bin/youki /usr/local/bin/youki
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
