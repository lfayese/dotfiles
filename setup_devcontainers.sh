#!/bin/bash
set -euo pipefail

echo "🐳 Setting up VSCode DevContainer support..."

mkdir -p .devcontainer

cat <<EOF > .devcontainer/devcontainer.json
{
  "name": "Dev Container",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "settings": {
    "terminal.integrated.shell.linux": "/bin/zsh"
  },
  "extensions": [
    "ms-azuretools.vscode-docker",
    "ms-vscode-remote.remote-containers"
  ]
}
EOF

cat <<EOF > .devcontainer/Dockerfile
FROM ubuntu:20.04

RUN apt-get update && apt-get install -y \
    curl git zsh sudo jq fzf ripgrep tmux \
    && rm -rf /var/lib/apt/lists/*

CMD [ "zsh" ]
EOF

echo "✅ DevContainer setup complete."
