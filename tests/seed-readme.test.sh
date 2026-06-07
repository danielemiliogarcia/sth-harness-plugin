#!/usr/bin/env bash
# Tests for scripts/seed-readme.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/seed-readme.sh"
pass=0; fail=0
check(){ if [ "$1" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $3 (got '$1' want '$2')"; fi; }

# 1: fresh dir -> README created with both links, exit 0
d1="$(mktemp -d)"
bash "$SCRIPT" "$d1" >/dev/null 2>&1; check "$?" "0" "exit 0 fresh"
grep -qF 'ai-harness/START-HERE.md' "$d1/README.md" && check yes yes "links START-HERE" || check no yes "links START-HERE"
grep -qF 'ai-harness/context/project.md' "$d1/README.md" && check yes yes "links project.md" || check no yes "links project.md"

# 2: pre-existing README -> skipped, content intact
d2="$(mktemp -d)"
printf '# Existing\n\nMy real readme.\n' > "$d2/README.md"
before="$(cat "$d2/README.md")"
bash "$SCRIPT" "$d2" >/dev/null 2>&1; check "$?" "0" "exit 0 existing"
check "$(cat "$d2/README.md")" "$before" "existing README untouched"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
