#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"
echo "🔧 WSL2 DNS Fix for Docker"

if grep -qi microsoft /proc/version; then
  echo "📍 WSL2 Detected"

  RESOLV_CONF="/etc/resolv.conf"
  if grep -q 127.0.0.1 "$RESOLV_CONF"; then
    echo "⚠️ DNS uses loopback (127.0.0.1), fixing..."

    sudo cp "$RESOLV_CONF" "$RESOLV_CONF.bak.$(date +%s)"
    echo -e "nameserver 8.8.8.8
nameserver 8.8.4.4" | sudo tee "$RESOLV_CONF"

    echo "[network]" | sudo tee /etc/wsl.conf
    echo "generateResolvConf = false" | sudo tee -a /etc/wsl.conf

    echo "✅ Updated DNS and disabled auto-generation"
    echo "🔁 Please run 'wsl --shutdown' and reopen WSL terminal"
  else
    echo "✅ DNS already configured with external servers"
  fi
else
  echo "❌ Not running in WSL2 environment"
fi
