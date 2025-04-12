# Optimized Dotfiles for Laolu Fayese

This bundle includes everything to bootstrap a developer environment with GPG, SSH, Docker, and GitLab config.

## 🔧 Setup Instructions

```bash
chmod +x bootstrap.sh
./bootstrap.sh
```

## 🧪 Test Your Environment

```bash
chmod +x test_env.sh
./test_env.sh
```

## 📂 Included

- `.bashrc.append`, `.zshrc.append` – shell config
- `.gitconfig.append` – Git user and GPG signing
- `.ssh/config` – SSH setup
- `.gnupg/gpg.conf` – GPG agent config
- `setup_docker.sh`, `bootstrap.sh` – Docker + WSL
- `.wslconfig`, `.docker/config.json` – Docker & WSL integration
- `test_env.sh` – automated environment tests

