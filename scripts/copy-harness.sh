#!/usr/bin/env bash
# Copy the bundled ai-harness template into a destination repo.
# Usage: copy-harness.sh [DEST_DIR]   (DEST_DIR defaults to $PWD)
# Exit: 0 ok | 1 destination already has ai-harness | 2 bundled template missing
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/../template/ai-harness"
DEST_ROOT="${1:-$PWD}"
DEST="$DEST_ROOT/ai-harness"

if [ ! -d "$SRC" ]; then
  echo "error: bundled template not found at $SRC" >&2
  exit 2
fi
if [ -e "$DEST" ]; then
  echo "error: ai-harness already exists at $DEST (refusing to overwrite)" >&2
  exit 1
fi

cp -R "$SRC" "$DEST"
echo "ai-harness installed at $DEST"
