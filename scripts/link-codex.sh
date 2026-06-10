#!/usr/bin/env bash
# Wire a repo's Codex memory to the ai-harness:
#   AGENTS.md -> pointer to ai-harness/START-HERE.md
# Idempotent; never overwrites existing content.
# Canonical adapter wording lives in ai-harness/tool-linking.md (mirrored below).
# Usage: link-codex.sh [DEST_DIR]   (DEST_DIR defaults to $PWD)
set -euo pipefail

DEST_ROOT="${1:-$PWD}"
AGENTS="$DEST_ROOT/AGENTS.md"

AGENTS_SNIPPET='# Agent Instructions

This repository uses a tool-agnostic AI harness.
**Start by reading `ai-harness/START-HERE.md` and follow its boot sequence.**
You work one feature per branch; current work lives in
`ai-harness/specs/<your-feature>/state.md`.
Keep this file thin; the harness is the single source of truth.'

if [ ! -f "$AGENTS" ]; then
  printf '%s\n' "$AGENTS_SNIPPET" > "$AGENTS"
  echo "AGENTS.md: created"
elif ! grep -qF 'ai-harness/START-HERE.md' "$AGENTS"; then
  printf '\n%s\n' "$AGENTS_SNIPPET" >> "$AGENTS"
  echo "AGENTS.md: appended"
else
  echo "AGENTS.md: skipped"
fi
