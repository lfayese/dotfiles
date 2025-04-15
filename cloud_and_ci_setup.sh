#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "🌍 Installing cloud CLIs and configuring CI/CD..."

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
# Check for existing AWS CLI installation
if [ -d "/usr/local/aws-cli/v2/current" ]; then
  echo "⚠️ Found preexisting AWS CLI installation. Running install script with --update flag."
  sudo ./aws/install --update
else
  sudo ./aws/install
fi

# GitHub Actions CI/CD template
mkdir -p .github/workflows

cat <<EOF > .github/workflows/release.yml
name: Release
on:
  push:
    tags:
      - '*'
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - run: chmod +x generate_changelog.sh && ./generate_changelog.sh
      - run: echo "🚀 Released!"
EOF

echo "✅ Cloud CLI and CI/CD setup complete."
