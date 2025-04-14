#!/bin/bash
set -euo pipefail

log_info()    { echo -e "[$(date +%F\ %T)] [INFO] $*"; }
log_warn()    { echo -e "[$(date +%F\ %T)] [WARN] $*" >&2; }
log_error()   { echo -e "[$(date +%F\ %T)] [ERROR] $*" >&2; }

trap_cleanup() {
  log_error "Script failed at line $1"
  exit 1
}
trap 'trap_cleanup $LINENO' ERR

safe_run() {
  log_info "Running: $*"
  "$@"
}

require_cmd() {
  for cmd in "$@"; do
    command -v "$cmd" >/dev/null || {
      log_error "Command not found: $cmd"
      exit 1
    }
  done
}

setup_tmp_dir() {
  TMP_DIR="$(mktemp -d)"
  trap "rm -rf \"$TMP_DIR\"" EXIT
  echo "$TMP_DIR"
}

confirm() {
  read -rp "$1 [y/N] " response
  [[ "$response" =~ ^[Yy]$ ]] || exit 1
}

is_wsl2() {
  grep -qi microsoft /proc/version
}
