#!/usr/bin/env bash
# Seed a minimal root README.md that links the ai-harness.
# Idempotent; never overwrites an existing README.
# Usage: seed-readme.sh [DEST_DIR]   (DEST_DIR defaults to $PWD)
set -euo pipefail

DEST_ROOT="${1:-$PWD}"
README="$DEST_ROOT/README.md"

if [ -f "$README" ]; then
  echo "README.md: skipped"
  exit 0
fi

cat > "$README" <<'EOF'
# Project

This repository uses the ai-harness for AI-assisted development.

- **Start here:** `ai-harness/START-HERE.md`
- **Project context (goal, tech, structure):** `ai-harness/context/project.md`

Replace this with a real project description; keep `ai-harness/context/project.md`
linked as the system-context hub.
EOF
echo "README.md: created"
