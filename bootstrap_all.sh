#!/bin/bash
set -euo pipefail

echo "🚀 Starting full bootstrap of the developer environment..."

# Run individual setup scripts
./install_cli_utilities.sh
./install_shell_enhancements.sh
./install_toolchains.sh
./setup_devcontainers.sh
./security_setup.sh
./cloud_and_ci_setup.sh

echo "🎉 All setup tasks completed successfully!"

# Final validation step
./validate_docker_setup.sh
