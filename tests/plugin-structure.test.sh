#!/usr/bin/env bash
# Contract tests: the static structure the commands and skills depend on.
# Catches broken references and the regression where a subagent leaked
# '--- END FILE ---' markers into shipped command/skill files.
set -uo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
pass=0; fail=0
check(){ if [ "$1" = "$2" ]; then pass=$((pass+1)); else fail=$((fail+1)); echo "FAIL: $3 (got '$1' want '$2')"; fi; }
exists(){ [ -e "$ROOT/$1" ] && check yes yes "$1 exists" || check no yes "$1 exists"; }

# Claude manifest valid + name; marketplace present
check "$(jq -r .name "$ROOT/.claude-plugin/plugin.json" 2>/dev/null)" "sth-harness" "plugin.json name"
exists ".claude-plugin/marketplace.json"
check "$(jq -r '.plugins[0].name' "$ROOT/.claude-plugin/marketplace.json" 2>/dev/null)" "sth-harness" "marketplace plugin name"

# Codex manifest valid + skills entry point
check "$(jq -r .name "$ROOT/.codex-plugin/plugin.json" 2>/dev/null)" "sth-harness" "codex plugin.json name"
check "$(jq -r .skills "$ROOT/.codex-plugin/plugin.json" 2>/dev/null)" "./skills/" "codex plugin skills path"
check "$(jq -r '.interface.displayName' "$ROOT/.codex-plugin/plugin.json" 2>/dev/null)" "sth-harness" "codex plugin display name"

# Pi package manifest valid + resource paths
check "$(jq -r .name "$ROOT/package.json" 2>/dev/null)" "sth-harness" "pi package name"
check "$(jq -r '.keywords | index("pi-package") != null' "$ROOT/package.json" 2>/dev/null)" "true" "pi-package keyword"
check "$(jq -r '.pi.skills[0]' "$ROOT/package.json" 2>/dev/null)" "./skills" "pi skills path"
check "$(jq -r '.pi.prompts[0]' "$ROOT/package.json" 2>/dev/null)" "./prompts" "pi prompts path"

# commands
for c in init add-spec execute-next-spec; do exists "commands/$c.md"; done
grep -qF 'Before finishing' "$ROOT/commands/init.md" && check yes yes "init checks placeholders before finishing" || check no yes "init checks placeholders before finishing"
grep -qF 'documentation-only occurrences' "$ROOT/commands/init.md" && check yes yes "init ignores documentation-only CUSTOMIZE mentions" || check no yes "init ignores documentation-only CUSTOMIZE mentions"

# Pi prompt templates
for p in sth-harness-init sth-harness-add-spec sth-harness-execute-next-spec; do exists "prompts/$p.md"; done

# skills the commands reference by name
for s in harness-interview harness-execute harness-tool-linking sth-harness; do exists "skills/$s/SKILL.md"; done

# scripts the commands and skills call, executable
for sc in copy-harness link-claude-code link-codex link-pi seed-readme; do
  exists "scripts/$sc.sh"
  [ -x "$ROOT/scripts/$sc.sh" ] && check yes yes "$sc.sh executable" || check no yes "$sc.sh executable"
done

# payload files the commands/skills reference at runtime
for p in START-HERE.md tool-linking.md roles.md context/architecture.md context/testing.md \
         specs/_template/spec.md specs/_template/state.md \
         specs/global-spec-info.md specs/global-state-info.md; do
  exists "template/ai-harness/$p"
done

# regression guard: no leaked delimiter markers in shipped command/skill/prompt files
if grep -rqn -- '--- END FILE ---' "$ROOT/commands" "$ROOT/skills" "$ROOT/prompts"; then
  check leaked clean "no '--- END FILE ---' markers in commands/skills/prompts"
else
  check clean clean "no '--- END FILE ---' markers in commands/skills/prompts"
fi

echo "pass=$pass fail=$fail"
[ "$fail" -eq 0 ]
