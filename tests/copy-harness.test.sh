#!/usr/bin/env bash
# Tests for scripts/copy-harness.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/copy-harness.sh"
pass=0; fail=0
check() { if [ "$1" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $3 (got '$1' want '$2')"; fi; }

# 1: installs into empty dir -> exit 0, START-HERE present
t1="$(mktemp -d)"
bash "$SCRIPT" "$t1" >/dev/null 2>&1; check "$?" "0" "exit 0 on empty dest"
[ -f "$t1/ai-harness/START-HERE.md" ] && check yes yes "START-HERE copied" || check no yes "START-HERE copied"

# 2: refuses to overwrite an existing ai-harness -> exit 1
bash "$SCRIPT" "$t1" >/dev/null 2>&1; check "$?" "1" "exit 1 when ai-harness exists"

# 3: missing bundled template -> exit 2
tmpplugin="$(mktemp -d)"; mkdir -p "$tmpplugin/scripts"; cp "$SCRIPT" "$tmpplugin/scripts/"
t3="$(mktemp -d)"
bash "$tmpplugin/scripts/copy-harness.sh" "$t3" >/dev/null 2>&1; check "$?" "2" "exit 2 when template missing"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
