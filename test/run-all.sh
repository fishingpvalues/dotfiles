#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" == MINGW* || "$(uname -s)" == CYGWIN* || "$(uname -s)" == MSYS* ]]; then
  echo "=== Running all Windows dotfiles tests ==="
  pwsh ./test/run-all.ps1
  exit $?
fi

if [[ "$(uname -s)" == "Darwin" ]]; then
  echo "=== Running all macOS dotfiles tests ==="
  ./test/test.sh
  exit $?
fi

for distro in ubuntu fedora arch alpine; do
  echo "\n=== Testing on $distro ==="
  docker build -f test/Dockerfile.$distro -t dotfiles-test-$distro .
  docker run --rm dotfiles-test-$distro
  echo "=== $distro test passed ===\n"
done 