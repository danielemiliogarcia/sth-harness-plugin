#!/usr/bin/env bash
# Tests for scripts/link-claude-code.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/link-claude-code.sh"
pass=0; fail=0
check(){ if [ "$1" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $3 (got '$1' want '$2')"; fi; }

# 1: fresh dir -> both files created with right content, exit 0
d1="$(mktemp -d)"
bash "$SCRIPT" "$d1" >/dev/null 2>&1; check "$?" "0" "exit 0 fresh"
grep -qF 'ai-harness/START-HERE.md' "$d1/AGENTS.md" && check yes yes "AGENTS has pointer" || check no yes "AGENTS has pointer"
grep -qF '@AGENTS.md' "$d1/CLAUDE.md" && check yes yes "CLAUDE imports AGENTS" || check no yes "CLAUDE imports AGENTS"

# 2: idempotent -> second run adds no lines
a_before="$(wc -l < "$d1/AGENTS.md")"; c_before="$(wc -l < "$d1/CLAUDE.md")"
bash "$SCRIPT" "$d1" >/dev/null 2>&1
check "$(wc -l < "$d1/AGENTS.md")" "$a_before" "AGENTS unchanged on rerun"
check "$(wc -l < "$d1/CLAUDE.md")" "$c_before" "CLAUDE unchanged on rerun"

# 3: pre-existing CLAUDE.md with user content -> @AGENTS.md appended, content kept
d3="$(mktemp -d)"
printf '# My Project\n\nSome rules.\n' > "$d3/CLAUDE.md"
bash "$SCRIPT" "$d3" >/dev/null 2>&1
grep -qF 'Some rules.' "$d3/CLAUDE.md" && check yes yes "user content kept" || check no yes "user content kept"
grep -qF '@AGENTS.md' "$d3/CLAUDE.md" && check yes yes "import appended" || check no yes "import appended"

# 4: pre-existing AGENTS.md already linked -> skipped (byte-identical)
d4="$(mktemp -d)"
printf 'see ai-harness/START-HERE.md\n' > "$d4/AGENTS.md"
before="$(cat "$d4/AGENTS.md")"
bash "$SCRIPT" "$d4" >/dev/null 2>&1
check "$(cat "$d4/AGENTS.md")" "$before" "AGENTS already-linked skipped"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
