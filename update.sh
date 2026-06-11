#!/usr/bin/env bash
set -e
pushd /home/thirst/nixos-config/

echo "Updating flake inputs..."
echo "WARNING: This updates ALL inputs blindly. Review flake.lock before rebuilding."
echo "To update a single input: nix flake lock --update-input <name>"
nix flake update

echo
echo "Flake lock diff:"
git diff flake.lock

popd

echo
echo "Update complete. Run ./rebuild.sh to apply the changes."
