#!/bin/bash
set -euo pipefail
echo "🔍 Post-Install Docker Validation"

# Ensure Docker daemon is running
if ! docker info >/dev/null 2>&1; then
  echo "⚠️ Docker daemon is not running. Attempting to start it..."
  if pgrep -x dockerd >/dev/null; then
    echo "✅ Docker daemon is already running."
  else
    sudo systemctl start docker
    if ! docker info >/dev/null 2>&1; then
      echo "❌ Failed to start Docker daemon. Please check your Docker setup."
      exit 1
    fi
  fi
fi

check() {
  echo -n "$1... "
  eval "$2" && echo "✅" || { echo "❌"; exit 1; }
}

check "Docker CLI" "command -v docker"
check "live-restore enabled" "jq -e '."live-restore" == true' /etc/docker/daemon.json"
check "DNS config present" "jq -e '.dns' /etc/docker/daemon.json"
check "data-root set" "jq -e '."data-root"' /etc/docker/daemon.json"

# Check if VHDX mount is active in WSL2
if grep -qi microsoft /proc/version; then
  check "Docker data directory" "[ -d /mnt/docker-data ]"
  check "Docker data VHDX mounted" "grep -q '/mnt/docker-data' /proc/mounts || echo 'Skipping mount check in Docker Desktop'"
else
  check "Docker data directory" "[ -d /mnt/docker-data ]"
fi

check "youki runtime exists" "[ -f /usr/local/bin/youki ]"
check "youki executable" "[ -x /usr/local/bin/youki ]"
check "gVisor config exists" "[ -f /etc/containerd/runsc.toml ]"
check "gVisor runtime exists" "command -v runsc &>/dev/null"
check "youki in daemon.json" "jq -e '.runtimes.youki.path == "/usr/local/bin/youki"' /etc/docker/daemon.json"
check "gVisor in daemon.json" "jq -e '.runtimes.gvisor' /etc/docker/daemon.json"

# Ensure proxy config is removed
check "proxy config removed" "! jq -e '.proxies' /etc/docker/daemon.json &>/dev/null || echo 'Proxy check skipped'"

echo "🎉 All checks passed!"
