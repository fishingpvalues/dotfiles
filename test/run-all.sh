#!/usr/bin/env bash
set -euo pipefail

for distro in ubuntu fedora arch alpine; do
  echo "\n=== Testing on $distro ==="
  docker build -f test/Dockerfile.$distro -t dotfiles-test-$distro .
  docker run --rm dotfiles-test-$distro
  echo "=== $distro test passed ===\n"
done 