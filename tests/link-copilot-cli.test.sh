#!/usr/bin/env bash
# Tests for scripts/link-copilot-cli.sh
set -uo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPT="$SCRIPT_DIR/../scripts/link-copilot-cli.sh"
TOOL_LINKING="$SCRIPT_DIR/../template/ai-harness/tool-linking.md"
pass=0; fail=0
check(){ if [ "$1" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $3 (got '$1' want '$2')"; fi; }

# 1: fresh dir -> AGENTS.md created with right content, exit 0
d1="$(mktemp -d)"
bash "$SCRIPT" "$d1" >/dev/null 2>&1; check "$?" "0" "exit 0 fresh"
grep -qF 'ai-harness/START-HERE.md' "$d1/AGENTS.md" && check yes yes "AGENTS has pointer" || check no yes "AGENTS has pointer"

# 2: idempotent -> second run adds no lines
a_before="$(wc -l < "$d1/AGENTS.md")"
bash "$SCRIPT" "$d1" >/dev/null 2>&1
check "$(wc -l < "$d1/AGENTS.md")" "$a_before" "AGENTS unchanged on rerun"

# 3: pre-existing AGENTS.md with user content -> snippet appended, content kept
d3="$(mktemp -d)"
printf '# My Project\n\nSome rules.\n' > "$d3/AGENTS.md"
bash "$SCRIPT" "$d3" >/dev/null 2>&1
grep -qF 'Some rules.' "$d3/AGENTS.md" && check yes yes "user content kept" || check no yes "user content kept"
grep -qF 'ai-harness/START-HERE.md' "$d3/AGENTS.md" && check yes yes "pointer appended" || check no yes "pointer appended"

# 4: pre-existing AGENTS.md already linked -> AGENTS skipped (byte-identical)
d4="$(mktemp -d)"
printf 'see ai-harness/START-HERE.md\n' > "$d4/AGENTS.md"
before="$(cat "$d4/AGENTS.md")"
bash "$SCRIPT" "$d4" >/dev/null 2>&1
check "$(cat "$d4/AGENTS.md")" "$before" "AGENTS already-linked skipped"

# 5: drift guard -> every non-empty line of the generated AGENTS.md exists verbatim
#    in the canonical snippet source (tool-linking.md). Fails if the two diverge.
drift=0
while IFS= read -r line; do
  [ -z "$line" ] && continue
  grep -qF -- "$line" "$TOOL_LINKING" || { drift=1; echo "  drift: not in tool-linking.md: $line"; }
done < "$d1/AGENTS.md"
check "$drift" "0" "AGENTS snippet matches canonical tool-linking.md"

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
