#!/usr/bin/env bash
set -euo pipefail

echo "Cleaning local build artifacts..."
rm -rf result/
rm -f nixos-switch.log

echo "Running Nix garbage collector..."
nix-collect-garbage -d

echo "Cleanup complete."
