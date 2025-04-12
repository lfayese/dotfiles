#!/bin/bash
set -euo pipefail
echo "🔍 Post-Install Docker Validation"

check() {
  echo -n "$1... "
  eval "$2" && echo "✅" || { echo "❌"; exit 1; }
}

check "Docker CLI" "command -v docker"
check "Docker Daemon Running" "docker info >/dev/null 2>&1"
check "live-restore enabled" "jq -e '."live-restore" == true' /etc/docker/daemon.json"
check "Proxy config present" "jq -e '.proxies' /etc/docker/daemon.json"
check "DNS config present" "jq -e '.dns' /etc/docker/daemon.json"
check "data-root set" "jq -e '."data-root"' /etc/docker/daemon.json"
check "youki runtime exists" "[ -f /usr/local/bin/youki ]"
check "gVisor config exists" "[ -f /etc/containerd/runsc.toml ]"
check "youki in daemon.json" "jq -e '.runtimes.youki.path == "/usr/local/bin/youki"' /etc/docker/daemon.json"

echo "🎉 All checks passed!"
