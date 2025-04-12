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
