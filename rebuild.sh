#!/usr/bin/env bash
set -e

cd ~/nixos-config

echo "=== Git Diff ==="
git diff

LOG=$(mktemp /tmp/nixos-rebuild-XXXXXX.log)
echo "=== Building (log: $LOG) ==="

sudo nixos-rebuild switch --flake ~/nixos-config#thinkpad 2>&1 | tee "$LOG"

echo ""
echo "=== Errors / Failures ==="
grep --color=always -iE "error|false" "$LOG" || echo "(none found)"

GENERATION=$(nixos-rebuild list-generations | grep current | awk '{print $1, $2, $3}')
COMMIT_MSG="nixos rebuild: generation $GENERATION"

echo ""
echo "=== Committing: $COMMIT_MSG ==="
git add -A
git commit -m "$COMMIT_MSG"
