# Optimized Dotfiles for Laolu Fayese

This bundle includes everything to bootstrap a developer environment with GPG, SSH, Docker, and GitLab config.

---

## 🚀 Quick Setup (Recommended)

```bash
chmod +x .install.sh
./.install.sh
```

This script will:
- Clone the dotfiles repo into `~/.dotfiles`
- Pull updates if already cloned
- Run the full `bootstrap.sh` setup

---

## 🧪 Test Your Environment

```bash
./test_env.sh
```

Checks:
- GPG key is installed
- Docker CLI is available
- Docker daemon is running
- Runs a test container

---

## 📂 Included

- `.bashrc.append`, `.zshrc.append` – shell config
- `.gitconfig.append` – Git user and GPG signing
- `.ssh/config` – SSH setup
- `.gnupg/gpg.conf` – GPG agent config
- `setup_docker.sh`, `bootstrap.sh` – Docker + WSL2
- `.wslconfig`, `.docker/config.json` – Docker & WSL
- `test_env.sh` – environment sanity check
- `.install.sh` – clone + bootstrap from GitHub
- `Makefile` – for install/test/clean automation

---

## 💻 Developer Notes

```bash
make install   # Run bootstrap
make test      # Run test_env.sh
make clean     # Remove installed test_env.sh
```

make fix-docker  # Attempt to fix Docker daemon if inaccessible
make doctor      # Full diagnostic: Docker, distro, user groups, and daemon.json
