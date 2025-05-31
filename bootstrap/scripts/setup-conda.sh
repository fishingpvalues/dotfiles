#!/usr/bin/env bash
set -euo pipefail

# This script configures conda environments and writes .condarc for the user.
# Usage: ./setup-conda.sh

CONDA_ENV_DIR="$HOME/.conda/envs"
MINIFORGE_ENV_DIR="$HOME/miniforge3/envs"

mkdir -p "$CONDA_ENV_DIR"

cat > "$HOME/.condarc" << EOF
envs_dirs:
  - $CONDA_ENV_DIR
  - $MINIFORGE_ENV_DIR
EOF

echo "Configured conda to store environments in $CONDA_ENV_DIR and $MINIFORGE_ENV_DIR."

# Optionally, ensure conda initialization is in shell profiles
declare -a SHELL_RCS=("$HOME/.bashrc" "$HOME/.zshrc")
for SHELL_RC in "${SHELL_RCS[@]}"; do
  if [ -f "$SHELL_RC" ]; then
    if ! grep -q "conda initialize" "$SHELL_RC"; then
      echo "Adding conda initialization to $SHELL_RC"
      SHELL_NAME=$(basename "$SHELL_RC" | sed 's/\.[^.]*$//')
      "$HOME/miniforge3/bin/conda" init "$SHELL_NAME"
    fi
  fi
done

echo "Conda initialization ensured in shell profiles." 