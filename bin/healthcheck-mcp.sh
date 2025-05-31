#!/usr/bin/env bash
# MCP/AI Health Check for Dotfiles (SOTA 2025)
set -euo pipefail

# Check for Python (for AI/MCP checks)
if ! command -v python3 &>/dev/null; then
  echo "[ERROR] Python 3 is required for MCP/AI health checks." >&2
  exit 1
fi

# Run MCP/AI health check (Python script inline or external)
python3 "$(dirname "$0")/healthcheck-mcp.py" "$@" 