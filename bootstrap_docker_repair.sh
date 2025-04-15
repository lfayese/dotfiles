#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "🚀 Starting Docker Repair & Enhancement Bootstrap..."

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Run each step in order
echo "🔧 Fixing Docker config..."
bash "$SCRIPT_DIR/fix_docker.sh"

echo "📦 Installing runtimes (youki + gVisor)..."
bash "$SCRIPT_DIR/install_runtimes.sh"

echo "🛠 Applying WSL2 DNS fixes (if applicable)..."
bash "$SCRIPT_DIR/fix_wsl2_dns.sh"

echo "🧪 Validating configuration..."
bash "$SCRIPT_DIR/validate_docker_setup.sh"

echo "🎉 All tasks completed successfully!"
