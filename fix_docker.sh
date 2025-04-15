#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

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

# Setup Docker data storage using VHDX in WSL2 or standard directory in Linux
DOCKER_DATA_DIR="/mnt/docker-data"
if grep -qi microsoft /proc/version; then
  echo "🧰 Setting up persistent Docker data storage using VHDX..."
  # Make the script executable if it isn't already
  chmod +x "$(dirname "${BASH_SOURCE[0]}")/create_docker_vhdx.sh"
  "$(dirname "${BASH_SOURCE[0]}")/create_docker_vhdx.sh"
else
  # Standard Linux - just make sure directory exists
  echo "📁 Creating Docker data directory at $DOCKER_DATA_DIR..."
  sudo mkdir -p "$DOCKER_DATA_DIR"
  sudo chown -R root:root "$DOCKER_DATA_DIR"
fi

# Configure data-root path in daemon.json
jq -e '.["data-root"]' "$DAEMON_JSON" &>/dev/null || merge_json_config "{\"data-root\": \"$DOCKER_DATA_DIR\"}"

# Remove proxy configuration if present (deprecated)
if jq -e '.proxies' "$DAEMON_JSON" &>/dev/null; then
  echo "🧹 Removing deprecated proxy configuration..."
  tmp_file=$(mktemp)
  jq 'del(.proxies)' "$DAEMON_JSON" > "$tmp_file" && sudo mv "$tmp_file" "$DAEMON_JSON"
fi

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

# Detect WSL2 environment and Docker Desktop
if grep -qi microsoft /proc/version; then
  echo "🪟 WSL2 environment detected"
  
  # Check if Docker Desktop is being used
  if grep -q docker-desktop /proc/self/mountinfo; then
    echo "🐋 Docker Desktop for Windows detected"
    
    # For Docker Desktop, we don't restart the daemon as it's managed by Windows
    if docker info &>/dev/null; then
      echo "✅ Docker Desktop is running and accessible from WSL2"
    else
      echo "⚠️ Docker Desktop is installed but not running"
      echo "👉 Please start Docker Desktop from Windows and ensure WSL integration is enabled for this distro"
      exit 1
    fi
  else
    # Standard Linux Docker service in WSL2
    echo "🐧 Native Linux Docker in WSL2 detected"
    if sudo systemctl is-active docker &>/dev/null; then
      sudo systemctl daemon-reexec
      sudo systemctl restart docker
    else
      sudo systemctl start docker
    fi
  fi
else
  # Standard Linux environment
  echo "🐧 Native Linux environment detected"
  sudo systemctl daemon-reexec
  sudo systemctl restart docker
fi

# Verify Docker is working
docker info &>/dev/null && echo "✅ Docker restarted with enhanced config" || echo "❌ Docker configuration failed"
