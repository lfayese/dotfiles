#!/bin/bash
set -euo pipefail
echo "🤖 Running CI/CD environment setup..."

# Install core utilities
sudo apt-get update
sudo apt-get install -y git curl unzip jq python3-pip

# Run setup scripts (excluding interactive ones like Docker Desktop validation)
./install_cli_utilities.sh
./install_toolchains.sh
./install_runtimes.sh
./cloud_and_ci_setup.sh

echo "✅ CI/CD setup complete."
