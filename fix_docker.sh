#!/bin/bash
set -euo pipefail

echo "🐳 Docker Daemon Auto-Fix Tool"

DAEMON_JSON="/etc/docker/daemon.json"
BACKUP_JSON="/etc/docker/daemon.json.bak.$(date +%s)"

backup_daemon_json() {
  if [[ -f $DAEMON_JSON ]]; then
    sudo cp "$DAEMON_JSON" "$BACKUP_JSON"
    echo "📦 Backup saved to $BACKUP_JSON"
  fi
}

merge_json_config() {
  local new_config="$1"
  tmp_file=$(mktemp)
  jq -s '.[0] * .[1]' "$DAEMON_JSON" <(echo "$new_config") > "$tmp_file" && sudo mv "$tmp_file" "$DAEMON_JSON"
}

# Check prerequisites
command -v docker &>/dev/null || { echo "❌ Docker not installed."; exit 1; }
command -v jq &>/dev/null || { echo "⚠️ Installing jq..."; sudo apt-get update && sudo apt-get install -y jq; }

[[ -f $DAEMON_JSON ]] || echo '{}' | sudo tee "$DAEMON_JSON" > /dev/null

backup_daemon_json

# Ensure valid JSON
jq empty "$DAEMON_JSON" || { echo "❌ Invalid JSON in daemon.json"; exit 1; }

# live-restore
jq -e '.["live-restore"] == true' "$DAEMON_JSON" &>/dev/null || merge_json_config '{"live-restore": true}'

# Add DNS config if missing
jq -e '.dns' "$DAEMON_JSON" &>/dev/null || merge_json_config '{"dns": ["8.8.8.8", "8.8.4.4"]}'

# data-root path
jq -e '.["data-root"]' "$DAEMON_JSON" &>/dev/null || merge_json_config '{"data-root": "/mnt/docker-data"}'

# proxy block
jq -e '.proxies' "$DAEMON_JSON" &>/dev/null || merge_json_config '{
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "localhost,127.0.0.1"
  }
}'

# Add youki and gVisor runtimes if not present
jq -e '.runtimes' "$DAEMON_JSON" &>/dev/null || merge_json_config '{
  "runtimes": {
    "youki": {
      "path": "/usr/local/bin/youki"
    },
    "gvisor": {
      "runtimeType": "io.containerd.runsc.v1",
      "options": {
        "TypeUrl": "io.containerd.runsc.v1.options",
        "ConfigPath": "/etc/containerd/runsc.toml"
      }
    }
  }
}'

# Restart Docker
sudo systemctl daemon-reexec
sudo systemctl restart docker
docker info && echo "✅ Docker restarted with enhanced config"
