# 🐳 dotfiles — Docker Fixer + WSL2 Enhancer + Dev Environment Toolkit

A modern, automated dotfiles and Docker toolkit for Linux, **Windows (via WSL2/Git Bash)**, and developer-focused machines. Provides full setup automation, shell enhancement, Docker repair, and secure development environment setup.

---

## 🚀 Features

### 🐳 Docker Enhancements
- Auto-configures `daemon.json` with:
  - ✅ `live-restore`
  - 🌐 DNS & Proxy
  - 📦 Container runtimes: `youki`, `gVisor`
  - 📁 Custom `data-root` support
- Full WSL2 DNS detection and repair
- One-command setup: `bootstrap_docker_repair.sh`
- Post-install validator ensures Docker is correctly configured

### 💻 Dotfiles & Shell Setup
- Append files for modular config: `.bashrc.append`, `.zshrc.append`, `.gitconfig.append`
- Safe dotfile linking via `symlink_dotfiles.sh`
- Config support for `.ssh`, `.gnupg`, `.vscode`, `.wslconfig`

### 🛠️ Developer Environment Setup
- `setup_docker.sh`: Bootstrap Docker engine
- `setup_vscode.sh`: Configure VSCode workspace
- `.vscode/settings.json`: Dev-ready IDE config

### 🧠 Shell & Tooling Boost
- CLI utility installer: `jq`, `htop`, `fzf`, `bat`, `ripgrep`, `tmux`, `gh`, `lazygit`
- Shell productivity: `zsh`, `powerlevel10k`, `zoxide`
- Toolchain management: `asdf`, `gcc`, `g++`, `gdb`, `lldb`

### 🐳 DevContainers
- `.devcontainer` setup for VSCode Remote Development
- Includes base `Dockerfile` and `devcontainer.json`

### 🔐 Security Setup
- SSH keygen and GitHub integration via `gh`
- GPG key creation and Git signing config
- Hardened `.ssh` and `.gnupg` settings

### ⚙️ CI/CD & Release Pipeline
- GitHub Actions:
  - Auto-release tags
  - Changelog generation with `generate_changelog.sh`
  - Version bumping via PR labels (`patch`, `minor`, `major`)
- `Makefile` with common automation targets

---

## 💻 OS Compatibility

| OS                  | Supported | Notes                               |
|---------------------|-----------|-------------------------------------|
| Linux               | ✅ Yes     | Full native support                 |
| Windows (WSL2)      | ✅ Yes     | Tested with Ubuntu/Debian on WSL2  |
| Windows (Git Bash)  | ✅ Partial | Symlink/config setup only          |

---

## 📦 Quickstart

### 🔧 Bootstrap Docker Setup Only

```bash
chmod +x bootstrap_docker_repair.sh
./bootstrap_docker_repair.sh
```

Includes:
- Docker daemon fixes
- Container runtime installs
- WSL2 DNS fix (if applicable)
- Docker health validation

---

## 🔂 Full Environment Setup

To install **everything**:

```bash
chmod +x bootstrap_all.sh
./bootstrap_all.sh
```

This will:
- Install CLI tools
- Enhance shell environment
- Install runtimes & compilers
- Set up DevContainers
- Configure SSH & GPG
- Run Docker validator ✅

---

## 🧰 File Overview

| File                        | Purpose |
|----------------------------|---------|
| `bootstrap_all.sh`         | Full environment setup |
| `bootstrap_docker_repair.sh` | Docker-only fix + validation |
| `install_cli_utilities.sh` | Installs terminal tools |
| `install_shell_enhancements.sh` | Zsh, powerlevel10k, zoxide |
| `install_toolchains.sh`    | asdf + language runtimes & compilers |
| `setup_devcontainers.sh`   | Sets up VSCode DevContainer |
| `security_setup.sh`        | SSH + GPG configuration |
| `generate_changelog.sh`    | Auto-generates changelog |
| `fix_docker.sh`            | Fixes Docker config |
| `install_runtimes.sh`      | Installs container runtimes |
| `fix_wsl2_dns.sh`          | Repairs WSL2 DNS |
| `validate_docker_setup.sh` | Docker post-install check |
| `setup_vscode.sh`          | IDE setup |
| `Makefile`                 | Task automation |
| `.vscode/settings.json`    | VSCode settings |
| `.wslconfig`               | WSL2 optimization |
| `.docker/config.json`      | Docker CLI config |
| `.ssh/config`              | SSH setup |
| `.gnupg/gpg.conf`          | GPG key setup |

---

## 📛 GitHub Badges

![Release](https://img.shields.io/github/v/release/lfayese/dotfiles)
![CI](https://github.com/lfayese/dotfiles/actions/workflows/release.yml/badge.svg)
![Last Commit](https://img.shields.io/github/last-commit/lfayese/dotfiles)

---

## 📜 Automated Versioning & Changelog

- Tags (e.g., `v1.3.0`) trigger:
  - Draft GitHub releases
  - Changelog generation via `release-drafter`
- Customize changelog in `.github/release-drafter.yml`

**To publish:**

```bash
git tag v1.4.0
git push origin v1.4.0
```

---

## 🔐 GPG Tag Signing

To GPG-sign your Git tags:

```bash
git tag -s v1.4.0 -m "Release v1.4.0"
git push origin v1.4.0
```

### Set up GPG:
```bash
git config --global user.signingkey YOURKEYID
git config --global commit.gpgsign true
```

Find your key:
```bash
gpg --list-secret-keys --keyid-format LONG
```

🔗 [Add GPG key to GitHub](https://docs.github.com/en/authentication/managing-commit-signature-verification)

---

## 👤 Developer Identity

- **Name**: Laolu Fayese  
- **Handle**: `systekLeno-gitgpg`  
- **Email**: `166741136+lfayese@users.noreply.github.com`  
- **GPG Key ID**: `6B9A3B918A0870C2`

---

## 📝 License

MIT — Fork, remix, and contribute freely.  
Secure dev environments are better for everyone. 🎯
