# 🐳 dotfiles — Docker Fixer + WSL2 Enhancer + Dev Environment Toolkit

A modern, automated dotfiles and Docker daemon fixer toolkit for Linux, **Windows (via WSL2/Git Bash)**, and developer-first machines.

---

## 🚀 Features

### 🐳 Docker Daemon Enhancements
- Auto-configures `daemon.json` with:
  - ✅ `live-restore`
  - 🌐 DNS & Proxy
  - 📦 `youki` and `gVisor` runtimes
  - 📁 `data-root` support
- Full WSL2 DNS detection and repair
- One-line installer: `bootstrap_docker_repair.sh`
- Post-install validator ensures runtime & Docker health

### 💻 Dotfiles & Shell Configs
- `.bashrc.append`, `.zshrc.append`, `.gitconfig.append` for clean, modular profile expansion
- `.install.sh` + `symlink_dotfiles.sh` auto-link configs safely

### 🛠️ Developer Environment Setup
- `setup_docker.sh` for Docker bootstrapping
- `setup_vscode.sh` for custom VSCode environment
- `.vscode/settings.json` for preconfigured IDE experience
- `.wslconfig` and `.ssh/config` + `.gnupg/gpg.conf` support

### ⚙️ Automation & Release Pipeline
- `Makefile` for task automation
- GitHub Actions CI:
  - `/workflows/release.yml`: triggers on push/merge to `main`
  - Auto-increments semantic version (patch/minor/major)
  - `release-drafter.yml` prepares changelogs

---

## 💻 OS Compatibility

| OS            | Supported | Notes |
|---------------|-----------|-------|
| Linux         | ✅ Yes     | Full native support |
| Windows (WSL2)| ✅ Yes     | Tested with Ubuntu/Debian on WSL2 |
| Windows (Git Bash) | ✅ Partial | Non-Docker features run (e.g. symlinks, config setup) |

---

## 📦 Quickstart

### 🔥 Run Everything with One Command

```bash
chmod +x bootstrap_docker_repair.sh
./bootstrap_docker_repair.sh
```

This will:
- Fix Docker daemon config
- Install runtimes
- Fix WSL2 DNS (if applicable)
- Run validator

---

## 🧰 File Overview

| File                        | Purpose |
|----------------------------|---------|
| `fix_docker.sh`            | Auto-fixes Docker daemon config |
| `install_runtimes.sh`      | Installs youki + gVisor runtimes |
| `fix_wsl2_dns.sh`          | Repairs DNS issues on WSL2 |
| `restore_docker_config.sh` | Restores previous good Docker config |
| `validate_docker_setup.sh` | Runs post-install health check |
| `setup_docker.sh`          | General Docker init setup |
| `bootstrap_docker_repair.sh` | One-command to run all Docker fixes |
| `.bashrc.append`, `.zshrc.append`, `.gitconfig.append` | Shell + Git additions |
| `symlink_dotfiles.sh`      | Safely links dotfiles to home dir |
| `setup_vscode.sh`          | Initializes VSCode dev environment |
| `Makefile`                 | Automation tasks |
| `.vscode/settings.json`    | VSCode project settings |
| `.wslconfig`               | Optimized WSL2 config |
| `.docker/config.json`      | Docker CLI settings |
| `.ssh/config`              | SSH client configuration |
| `.gnupg/gpg.conf`          | GPG key agent configuration |

---

## 📦 Auto Versioning

GitHub Actions will automatically:
- Draft releases with changelogs
- Bump patch/minor/major versions based on merged PR labels (`patch`, `minor`, `major`)

To publish a version manually:

```bash
git tag v1.2.0
git push origin --tags
```

---

## 📜 License

MIT – Feel free to copy, fork, and remix responsibly. Contributions welcome!

---

## 🔁 Auto Version Bumping (CI/CD)

This project includes a GitHub Actions workflow that automatically bumps the version tag
when new files are merged into the `main` branch. It uses the `release-drafter` GitHub app
and semver-based tags (`v1.2.0`, `v1.3.0`, etc).

🔧 To enable this:
1. Enable the [Release Drafter GitHub App](https://github.com/apps/release-drafter)
2. Merge any PR into `main`
3. A draft release and version tag is generated automatically

You can customize this in `.github/release-drafter.yml`.


---

## 🪟 Windows Compatibility

This toolkit works on **Windows 10/11** via **WSL2**:

- Make sure [WSL2 is installed](https://docs.microsoft.com/en-us/windows/wsl/install)
- Recommended distros: Ubuntu, Debian
- Open **WSL terminal** and run:

```bash
./bootstrap_docker_repair.sh
```

All scripts are POSIX-compliant and tested in Ubuntu/Debian WSL2 environments.

---

## 🔂 One Command to Rule Them All

To run everything from start to finish:

```bash
chmod +x bootstrap_docker_repair.sh
./bootstrap_docker_repair.sh
```

This will:
- Fix your Docker configuration
- Install container runtimes (youki + gVisor)
- Fix WSL2 DNS if needed
- Validate everything at the end ✅

---

## 📛 GitHub Badges

![Release](https://img.shields.io/github/v/release/lfayese/dotfiles)
![CI](https://github.com/lfayese/dotfiles/actions/workflows/release.yml/badge.svg)
![Last Commit](https://img.shields.io/github/last-commit/lfayese/dotfiles)

---

## 📝 Automated Changelog Per Tag

Each time a new version is tagged (e.g., `v1.2.0`), GitHub Actions and Release Drafter will:
- Automatically generate release notes with new features, fixes, and contributors
- Update the "Releases" tab with the latest info

🎯 To create a new version and trigger changelog:
```bash
git tag v1.3.0
git push origin v1.3.0
```

Customize changelog behavior in `.github/release-drafter.yml`.

---

## 🔐 GPG Tag Signing

To sign a Git tag with your GPG key:

```bash
git tag -s v1.4.0 -m "Release v1.4.0"
git push origin v1.4.0
```

Make sure your key is set up with Git:
```bash
git config --global user.signingkey YOURKEYID
git config --global commit.gpgsign true
```

To list your available GPG keys:
```bash
gpg --list-secret-keys --keyid-format LONG
```

Use GitHub's GPG guide to add your public key to your GitHub account:
🔗 https://docs.github.com/en/authentication/managing-commit-signature-verification


---

## 🧰 Extended Features in This Toolkit

### ✅ Full Bootstrap Installer
Run everything with:

```bash
chmod +x bootstrap_all.sh
./bootstrap_all.sh
```

This will install:
- CLI utilities: jq, htop, fzf, bat, ripgrep, tmux, gh, lazygit
- Shell enhancements: Zsh, powerlevel10k, zoxide
- Toolchain managers: asdf (Node.js, Python, Ruby), compilers (gcc, g++, gdb, lldb)
- DevContainer setup (.devcontainer/Dockerfile + devcontainer.json)
- Security: SSH key generation, GitHub CLI integration, GPG key setup
- Automation: GitHub Actions CI/CD, changelog generation

The process ends by validating your Docker setup to ensure all configurations were successful.

---

## 🔐 Identity & Signing

**Developer Identity**
- Name: Laolu Fayese
- GPG Handle: systekLeno-gitgpg
- Email: 166741136+lfayese@users.noreply.github.com
- GPG Key ID: `6B9A3B918A0870C2`

Note: Any tokens or credentials should be managed securely and never committed to version control.
