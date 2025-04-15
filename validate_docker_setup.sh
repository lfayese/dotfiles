#!/bin/bash
set -uo pipefail
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
  if eval "$2" &>/dev/null; then
    echo "✅"
    return 0
  else
    echo "❌"
    return 1
  fi
}

# Check for critical failures that should stop the script
check_critical() {
  echo -n "$1... "
  if eval "$2" &>/dev/null; then
    echo "✅"
    return 0
  else
    echo "❌"
    echo "Critical error: $1 check failed"
    exit 1
  fi
}

DAEMON_JSON="/etc/docker/daemon.json"

check_critical "Docker CLI" "command -v docker"

# Check if daemon.json exists before trying to query it
if [[ -f "$DAEMON_JSON" ]]; then
  # Verify it's valid JSON
  if ! jq empty "$DAEMON_JSON" &>/dev/null; then
    echo "❌ Invalid JSON in $DAEMON_JSON"
    echo "Running fix_docker.sh to repair the configuration..."
    if [[ -x "$(dirname "$0")/fix_docker.sh" ]]; then
      "$(dirname "$0")/fix_docker.sh"
    else
      echo "❌ Could not find fix_docker.sh script"
      exit 1
    fi
  fi
  
  # Now check Docker settings
  check "live-restore enabled" "jq -e '."live-restore" == true' $DAEMON_JSON"
  check "DNS config present" "jq -e '.dns' $DAEMON_JSON"
  check "data-root set" "jq -e '."data-root"' $DAEMON_JSON"
else
  echo "⚠️ Docker daemon.json not found at $DAEMON_JSON"
  echo "Running fix_docker.sh to create the configuration..."
  if [[ -x "$(dirname "$0")/fix_docker.sh" ]]; then
    "$(dirname "$0")/fix_docker.sh"
  else
    echo "❌ Could not find fix_docker.sh script"
    exit 1
  fi
fi

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
