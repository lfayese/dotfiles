#!/bin/bash
set -e

echo "🔧 Starting enhanced dotfiles bootstrap..."

# --- CONFIG ---
GITHUB_USER="lfayese"   # 👈 change this before running
GPG_KEY_EMAIL="166741136+lfayese@users.noreply.github.com"     # 👈 required to pull GPG from GitHub
DEFAULT_KEY_TYPE="ed25519"

# --- SSH Setup ---
mkdir -p ~/.ssh && chmod 700 ~/.ssh

# Auto-generate SSH key if not found
if ! ls ~/.ssh/id_${DEFAULT_KEY_TYPE} 1>/dev/null 2>&1; then
  echo "⚠️ No SSH key found, generating one..."
  ssh-keygen -t $DEFAULT_KEY_TYPE -f ~/.ssh/id_${DEFAULT_KEY_TYPE} -N "" -C "$GPG_KEY_EMAIL"
fi

# Copy SSH config
cp .ssh/config ~/.ssh/config
chmod 600 ~/.ssh/config

# --- GPG Setup ---
mkdir -p ~/.gnupg && chmod 700 ~/.gnupg
cp .gnupg/gpg.conf ~/.gnupg/gpg.conf
chmod 600 ~/.gnupg/gpg.conf

# Attempt to fetch GPG key from GitHub
if ! gpg --list-keys "$GPG_KEY_EMAIL" >/dev/null 2>&1; then
  echo "🌐 Fetching GPG key from GitHub..."
  curl -s "https://github.com/$GITHUB_USER.gpg" | gpg --import
else
  echo "✅ GPG key already exists locally."
fi

# Extract GPG key ID
GPG_KEY_ID=$(gpg --list-secret-keys --keyid-format LONG "$GPG_KEY_EMAIL" | grep 'sec' | awk '{print $2}' | cut -d'/' -f2 | head -n 1)

# Replace placeholders in templates
sed "s/YOUR_GPG_KEY_ID/$GPG_KEY_ID/" .gitconfig.append > ~/.gitconfig.append.tmp
cat ~/.gitconfig.append.tmp >> ~/.gitconfig && rm ~/.gitconfig.append.tmp

sed "s/YOUR_GPG_KEY_ID/$GPG_KEY_ID/" .gnupg/gpg.conf > ~/.gnupg/gpg.conf

# --- Shell Setup (bash + zsh) ---
if [ -n "$ZSH_VERSION" ]; then
  SHELL_RC=~/.zshrc
  APPEND_FILE=.zshrc.append
else
  SHELL_RC=~/.bashrc
  APPEND_FILE=.bashrc.append
fi

if ! grep -q "### DOTFILES-BOOTSTRAP-START" "$SHELL_RC"; then
  echo "Appending to $SHELL_RC..."
  cat "$APPEND_FILE" >> "$SHELL_RC"
fi

echo "✅ All done! Reload your shell:"
echo "source $SHELL_RC"


# --- GitLab PAT Setup ---
echo "📡 Configuring GitLab access..."
cat <<EOF > ~/.netrc
machine gitlab.com
login lfayese
password gloat-gR_Uvj3pzychoDe18WLG
EOF
chmod 600 ~/.netrc

# --- Docker Setup Verification ---
echo "🧪 Checking Docker setup inside bootstrap..."

if ! command -v docker &>/dev/null; then
    echo "❌ Docker CLI not found. Please install Docker Desktop and ensure WSL integration is enabled."
    exit 1
fi

echo "✅ Docker CLI is available."

if ! docker info &>/dev/null; then
    echo "⚠️ Docker daemon not accessible."
    echo "👉 Make sure Docker Desktop is running and WSL integration is enabled for this distro."
    echo "   Try launching Docker Desktop manually or run: 'wsl --shutdown' and restart Docker."
    exit 1
fi

echo "✅ Docker daemon is accessible."

if groups | grep -qv '\bdocker\b'; then
    echo "⚠️ Current user is not in the 'docker' group."
    echo "👉 Consider running: sudo usermod -aG docker $USER && newgrp docker"
fi

echo "🚀 Running a test container..."
docker run --rm hello-world

echo "🎉 Docker setup validated successfully!"

# --- Test Environment Setup ---
echo "🧪 Installing environment test script..."
cat <<EOF > ~/test_env.sh
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
EOF

chmod +x ~/test_env.sh
echo "📦 Test script installed at ~/test_env.sh"
