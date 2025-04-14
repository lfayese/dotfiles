#!/bin/bash
set -euo pipefail
source "$(dirname "${BASH_SOURCE[0]}")/lib/common.sh"

echo "📜 Generating CHANGELOG.md from Git tags and commit history"

{
  echo "# 📦 CHANGELOG"
  echo
  git for-each-ref --sort=-creatordate --format '%(refname:short)' refs/tags | while read tag; do
    echo "## 🔖 $tag"
    echo
    git log --pretty=format:'- %s (%an)' $(git describe --tags --abbrev=0 $tag^ 2>/dev/null || echo HEAD).."$tag" || true
    echo
  done
} > CHANGELOG.md

echo "✅ CHANGELOG.md updated."
