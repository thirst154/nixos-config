#!/usr/bin/env bash
set -e
pushd ~/nixos-config/

if git diff --quiet; then
    echo "No changes detected, exiting."
    popd
    exit 0
fi

# Autoformat your nix files
alejandra . \
  || ( echo "formatting failed!"; exit 1)

# Shows your changes
git diff -U0 '*.nix'

echo "NixOS Rebuilding..."
sudo -v
sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad &>nixos-switch.log || (
    cat nixos-switch.log | grep -iE --color 'error|warning'; exit 1)

# Get current generation ID
gen=$(sudo nixos-rebuild list-generations | grep current | awk '{print $1}')

# Stage and commit with generation ID
git add -A
git commit -m "Generation $gen"

# Back to where you were
popd

# Notify all OK!
notify-send -e "NixOS Rebuilt OK!" --icon=software-update-available 2>/dev/null || true
