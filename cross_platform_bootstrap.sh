#!/bin/bash
set -euo pipefail
echo "🌍 Detecting platform for cross-platform install..."

OS=$(uname -s)
if grep -qEi "(Microsoft|WSL)" /proc/version 2>/dev/null; then
  PLATFORM="WSL"
elif [[ "$OS" == "Darwin" ]]; then
  PLATFORM="macOS"
elif [[ "$OS" == "Linux" ]]; then
  PLATFORM="Linux"
else
  echo "❌ Unsupported platform: $OS"
  exit 1
fi

echo "🔎 Platform detected: $PLATFORM"

case "$PLATFORM" in
  "WSL"|"Linux")
    sudo apt-get update && sudo apt-get install -y curl unzip git python3-pip
    ;;
  "macOS")
    # Check for Homebrew
    if ! command -v brew &>/dev/null; then
      echo "🍺 Installing Homebrew..."
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    brew install git curl unzip jq python3
    ;;
esac

# Run all setup scripts
./install_cli_utilities.sh
./install_toolchains.sh
./install_runtimes.sh
./setup_docker.sh
./setup_devcontainers.sh
./install_shell_enhancements.sh
./security_setup.sh
./cloud_and_ci_setup.sh
./validate_docker_setup.sh

echo "🎉 Cross-platform bootstrap complete!"
