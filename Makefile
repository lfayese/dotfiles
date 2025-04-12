# Makefile for dotfiles setup

install:
	@echo "🚀 Running bootstrap..."
	chmod +x ./bootstrap.sh
	./bootstrap.sh

test:
	@echo "🧪 Running environment tests..."
	./test_env.sh

clean:
	rm -f ~/test_env.sh
	@echo "🧹 Cleaned up test_env.sh"

all: install test

fix-docker:
	@./fix_docker.sh


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
	@echo "✅ Diagnostics complete."


update:
	@git pull origin main || echo "⚠️ Failed to pull. Are you in a git repo?"
