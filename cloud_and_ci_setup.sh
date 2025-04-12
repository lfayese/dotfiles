#!/bin/bash
set -euo pipefail

echo "🌍 Installing cloud CLIs and configuring CI/CD..."

# Install AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip -o awscliv2.zip
sudo ./aws/install

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
