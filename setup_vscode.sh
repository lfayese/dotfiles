#!/bin/bash
echo "🛠 Installing VSCode CLI extensions..."

code --install-extension ms-vscode-remote.remote-wsl
code --install-extension ms-azuretools.vscode-docker
code --install-extension ms-vscode.cpptools
code --install-extension ms-python.python
code --install-extension GitHub.copilot
code --install-extension eamodio.gitlens

echo "✅ VSCode extensions installed."
