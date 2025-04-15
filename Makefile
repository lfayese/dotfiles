# Makefile for dotfiles setup

# Main deployment targets
install:
	@echo "🚀 Running bootstrap..."
	@chmod +x ./bootstrap.sh
	./bootstrap.sh

deploy-all: deps install-cli install-shell install-toolchains install-runtimes docker-setup symlink-dotfiles setup-vscode security-setup test
	@echo "🎉 Complete dotfiles setup finished!"

deploy-minimal: deps install-cli docker-setup symlink-dotfiles test
	@echo "🎉 Minimal dotfiles setup finished!"

deploy-wsl: deps install-cli install-shell docker-setup wsl-dns-fix symlink-dotfiles test
	@echo "🎉 WSL-optimized setup finished!"

test:
	@echo "🧪 Running environment tests..."
	@chmod +x ./test_env.sh
	./test_env.sh

clean:
	rm -f ~/test_env.sh
	@echo "🧹 Cleaned up test_env.sh"

all: deploy-all

fix-docker:
	@chmod +x ./fix_docker.sh
	@./fix_docker.sh

vhdx-create:
	@echo "💾 Creating Docker data VHDX..."
	@chmod +x ./create_docker_vhdx.sh
	@./create_docker_vhdx.sh

vhdx-info:
	@echo "ℹ️ VHDX Storage Information:"
	@if [ -f /mnt/wslg/docker-data.vhdx ]; then \
		echo "📁 VHDX Path: /mnt/wslg/docker-data.vhdx"; \
		echo "📊 VHDX Size: $$(du -h /mnt/wslg/docker-data.vhdx | cut -f1)"; \
	else \
		echo "❌ VHDX file not found at /mnt/wslg/docker-data.vhdx"; \
	fi
	@if grep -q "/mnt/docker-data" /proc/mounts; then \
		echo "✅ VHDX is mounted at /mnt/docker-data"; \
		echo "💽 Available space: $$(df -h /mnt/docker-data | awk 'NR==2 {print $$4}')"; \
	else \
		echo "⚠️ VHDX is not currently mounted"; \
	fi

docker-setup: vhdx-create fix-docker
	@echo "🔍 Validating Docker setup..."
	@chmod +x ./validate_docker_setup.sh
	@./validate_docker_setup.sh


docker-validate:
	@echo "🔍 Validating Docker setup..."
	@chmod +x ./validate_docker_setup.sh
	@./validate_docker_setup.sh

docker-restore:
	@echo "🔄 Restoring Docker configuration from backup..."
	@chmod +x ./restore_docker_config.sh
	@./restore_docker_config.sh

wsl-dns-fix:
	@echo "🌐 Applying WSL2 DNS fixes..."
	@chmod +x ./fix_wsl2_dns.sh
	@./fix_wsl2_dns.sh

runtimes-install:
	@echo "📦 Installing container runtimes (youki + gVisor)..."
	@chmod +x ./install_runtimes.sh
	@./install_runtimes.sh

doctor:
	@echo "🩺 Running full dotfiles environment diagnostics..."
	@chmod +x ./test_env.sh || true
	@./test_env.sh || true
	@echo "🧠 Distro Info:"
	@cat /etc/os-release 2>/dev/null || lsb_release -a || echo "⚠️ Cannot detect distribution"
	@echo "👤 Docker Group:"
	@id -nG | grep docker || echo "⚠️ User is NOT in the docker group"
	@echo "📄 Daemon Config:"
	@cat /etc/docker/daemon.json 2>/dev/null || echo "⚠️ No daemon.json found"
	@echo "🗄️ VHDX Status:"
	@$(MAKE) -s vhdx-info 2>/dev/null || echo "⚠️ VHDX not set up or not in WSL2"
	@echo "✅ Diagnostics complete."


update:
	@git pull origin main || echo "⚠️ Failed to pull. Are you in a git repo?"


reset:
	@git fetch origin
	@git reset --hard origin/main
	@git clean -fd
	@echo "🔁 Repository has been reset to match origin/main"


deps:
	@echo "📦 Verifying required system packages..."
	@bash -c 'DEPS=(git curl gpg docker); \
	for pkg in "${DEPS[@]}"; do \
	  if ! command -v $$pkg &>/dev/null; then \
	    echo "❌ Missing: $$pkg"; \
	  else \
	    echo "✅ Found: $$pkg"; \
	  fi; \
	done'
