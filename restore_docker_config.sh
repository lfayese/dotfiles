#!/bin/bash
set -euo pipefail

DAEMON_JSON="/etc/docker/daemon.json"
BACKUPS=(/etc/docker/daemon.json.bak.*)
LATEST_BACKUP="${BACKUPS[-1]}"

[[ ${#BACKUPS[@]} -eq 0 ]] && { echo "❌ No backups to restore."; exit 1; }

echo "🔁 Restoring daemon.json from $LATEST_BACKUP"
sudo cp "$LATEST_BACKUP" "$DAEMON_JSON"

jq empty "$DAEMON_JSON" || { echo "❌ Restored config invalid"; exit 1; }

sudo systemctl daemon-reexec
sudo systemctl restart docker
docker info && echo "✅ Docker restored from backup"
