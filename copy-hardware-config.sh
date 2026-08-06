#!/usr/bin/env bash
set -euo pipefail

DEST="hosts/thinkpad/hardware-configuration.nix"

sudo cp /etc/nixos/hardware-configuration.nix "$DEST"
sudo chown "$(id -u):$(id -g)" "$DEST"
