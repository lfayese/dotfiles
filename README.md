# 🐳 Docker Auto-Repair & Enhancement Toolkit

A complete toolkit to automatically diagnose, fix, and upgrade your Docker Engine configuration on **Linux**, **WSL2**, **Ubuntu**, and **Debian**.

## 🚀 Features

- ✅ Auto-fix common `daemon.json` misconfigurations
- 🔁 Backup and restore Docker config
- 🌐 Add DNS, proxy, data-root, and live-restore settings
- 📦 Install container runtimes: `youki`, `gVisor` + containerd shims
- 🛠 Detect & fix WSL2 DNS quirks (`dnsmasq`, `resolv.conf`)
- 🧪 Post-install validator ensures everything works

---

## 📦 Quickstart

```bash
git clone https://github.com/your-username/docker-auto-repair-toolkit.git
cd docker-auto-repair-toolkit
chmod +x *.sh
./bootstrap_docker_repair.sh
```

---

## 🔧 Toolkit Components

| Script                        | Description                                                                 |
|------------------------------|-----------------------------------------------------------------------------|
| `bootstrap_docker_repair.sh` | 🧙 Master installer chaining everything below                               |
| `fix_docker.sh`              | 🛠 Updates `daemon.json` with DNS, proxy, data-root, runtimes, live-restore |
| `restore_docker_config.sh`   | 🧯 Restores last working Docker configuration                              |
| `install_runtimes.sh`        | 📦 Installs `youki`, `gVisor`, and sets up containerd runtime support      |
| `fix_wsl2_dns.sh`            | 🧰 Detects/fixes WSL2 DNS loopback issues (`dnsmasq`, `resolv.conf`)       |
| `validate_docker_setup.sh`   | ✅ Post-install validator: checks runtimes, DNS, Docker daemon health      |

---

## 🧠 Requirements

- Docker Engine (pre-installed)
- `jq`, `curl`, and optionally `cargo` (for `youki`)
- WSL2 with Debian/Ubuntu (if using on Windows)

---

## 🧪 What It Fixes

- Invalid or missing `/etc/docker/daemon.json`
- Docker daemon not starting
- No external DNS or proxy config
- Missing container runtimes for secure/isolated workloads
- Broken WSL2 DNS via `127.0.0.1` resolvers

---

## 🐧 WSL2-Specific Support

If you're using **WSL2**, this toolkit will:
- Detect the environment
- Fix DNS misconfigurations
- Prevent `/etc/resolv.conf` from being auto-overwritten
- Restart Docker/WSL safely when needed

---

## 🛠 Example `daemon.json` Output

```json
{
  "live-restore": true,
  "dns": ["8.8.8.8", "8.8.4.4"],
  "data-root": "/mnt/docker-data",
  "proxies": {
    "http-proxy": "http://proxy.example.com:3128",
    "https-proxy": "https://proxy.example.com:3129",
    "no-proxy": "localhost,127.0.0.1"
  },
  "runtimes": {
    "youki": {
      "path": "/usr/local/bin/youki"
    },
    "gvisor": {
      "runtimeType": "io.containerd.runsc.v1",
      "options": {
        "TypeUrl": "io.containerd.runsc.v1.options",
        "ConfigPath": "/etc/containerd/runsc.toml"
      }
    }
  }
}
```

---

## 🧰 Want to Extend?

Suggestions and contributions welcome! You can:
- Add more container runtimes
- Support other platforms (macOS, RHEL)
- Build a GUI frontend (we're thinking about it 😉)

---

## 📜 License

MIT — use responsibly, contributions welcome, no warranty.
