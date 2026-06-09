#!/usr/bin/env bash
set -e
pushd /home/thirst/nixos-config/

echo "Updating flake inputs..."
nix flake update

echo
echo "Flake lock diff:"
git diff flake.lock

popd

echo
echo "Update complete. Run ./rebuild.sh to apply the changes."
