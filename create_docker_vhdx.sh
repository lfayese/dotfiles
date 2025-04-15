#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "💾 Creating Docker data VHDX for persistent storage"

# Configuration
VHDX_SIZE="20G"  # Size of the VHDX file
VHDX_PATH="/mnt/wslg/docker-data.vhdx"  # Path to store the VHDX file
MOUNT_POINT="/mnt/docker-data"  # Where to mount the VHDX

# Check if running in WSL2
if ! grep -qi microsoft /proc/version; then
  echo "⚠️ This script is designed for WSL2 environments only"
  echo "🔄 For native Linux, using standard directories instead..."
  sudo mkdir -p "$MOUNT_POINT"
  echo "✅ Created $MOUNT_POINT directory"
  exit 0
fi

# Create the VHDX file if it doesn't exist
if [ ! -f "$VHDX_PATH" ]; then
  echo "🛠 Creating new VHDX file at $VHDX_PATH ($VHDX_SIZE)"
  sudo mkdir -p "$(dirname "$VHDX_PATH")"
  sudo dd if=/dev/zero of="$VHDX_PATH" bs=1 count=0 seek=$VHDX_SIZE
  sudo mkfs.ext4 "$VHDX_PATH"
  echo "✅ VHDX file created and formatted"
else
  echo "✅ Found existing VHDX file at $VHDX_PATH"
fi

# Ensure mount point exists
sudo mkdir -p "$MOUNT_POINT"

# Check if already mounted
if grep -q "$MOUNT_POINT" /proc/mounts; then
  echo "✅ $VHDX_PATH is already mounted at $MOUNT_POINT"
else
  echo "🔄 Mounting VHDX to $MOUNT_POINT"
  sudo mount -o loop "$VHDX_PATH" "$MOUNT_POINT"
  echo "✅ VHDX mounted successfully"
fi

# Add entry to /etc/fstab for persistent mounting
if ! grep -q "$VHDX_PATH" /etc/fstab; then
  echo "📝 Adding mount entry to /etc/fstab for persistence"
  echo "$VHDX_PATH $MOUNT_POINT ext4 loop,defaults 0 0" | sudo tee -a /etc/fstab
fi

echo "🎉 Docker data VHDX setup complete!"
