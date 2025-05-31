#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

if [ -x "$SCRIPT_DIR/scripts/install-linux.sh" ]; then
  exec "$SCRIPT_DIR/scripts/install-linux.sh" "$@"
else
  echo "Error: bootstrap/scripts/install-linux.sh not found or not executable." >&2
  exit 1
fi 