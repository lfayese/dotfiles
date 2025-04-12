#!/bin/bash
set -euo pipefail

echo "🔍 Running environment tests..."

# --- Test GPG Setup ---
echo "🔐 Testing GPG key presence..."
if ! gpg --list-secret-keys --keyid-format LONG 166741136+lfayese@users.noreply.github.com >/dev/null 2>&1; then
  echo "❌ GPG key not found."
  exit 1
else
  echo "✅ GPG key is available."
fi

# --- Test Docker Setup ---
echo "🐳 Testing Docker CLI availability..."
if ! command -v docker &>/dev/null; then
  echo "❌ Docker CLI not found."
  exit 1
else
  echo "✅ Docker CLI is available."
fi

echo "🔄 Checking Docker daemon..."
if ! docker info &>/dev/null; then
  echo "❌ Docker daemon is not running or inaccessible."
  exit 1
else
  echo "✅ Docker daemon is running."
fi

echo "🧪 Running hello-world Docker container..."
docker run --rm hello-world

echo "🎉 All tests passed successfully!"
