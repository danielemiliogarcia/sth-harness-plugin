---
name: harness-tool-linking
description: Detect which AI tool the user runs and write the matching ai-harness adapter file(s). Claude Code fully automated; other tools recognized and given a manual snippet. Used by /sth-harness:init.
---

# Harness Tool Linking

Wire the user's AI tool to the installed harness so the tool bootstraps from
`ai-harness/START-HERE.md`. Run AFTER `ai-harness/` is installed.

## 1. Determine the tool (detect, then confirm)
- If the environment has `CLAUDECODE` or `CLAUDE_PLUGIN_ROOT` set, propose
  **Claude Code** and ask the user to confirm or pick another.
- If there is no signal, ask the user to choose from: Claude Code, Codex,
  GitHub Copilot, Gemini CLI, Pi, Aider, Other.

## 2. Read the canonical snippets
Open `ai-harness/tool-linking.md` — it holds the recommended adapter file and
snippet for each tool. Use it as the source of truth for wording.

## 3. Branch by tool

### Claude Code (fully automated)
Run the bundled wiring script:
`bash "${CLAUDE_PLUGIN_ROOT}/scripts/link-claude-code.sh" "$PWD"`
Report its per-file actions (`created | appended | skipped`). End state:
Claude Code reads `CLAUDE.md` -> `@AGENTS.md` -> `AGENTS.md` -> bootstraps
`ai-harness/START-HERE.md`. The script is idempotent and never clobbers
existing content.

### Codex / GitHub Copilot / Gemini CLI / Pi / Aider (recognized, not yet automated)
Auto-wiring for these is a planned extension. For now:
1. Tell the user which adapter file their tool reads (from `tool-linking.md`):
   Codex -> `AGENTS.md`; Copilot -> `.github/copilot-instructions.md`;
   Gemini -> `GEMINI.md`; Pi -> `PI.md`; Aider -> `CONVENTIONS.md`.
2. Print the matching snippet from `ai-harness/tool-linking.md`.
3. Tell them to create that file with the snippet; note auto-wiring is coming.
Do NOT write the file automatically.

### Other / unknown
Point the user at the general pattern in `ai-harness/tool-linking.md` ("How to
add an adapter") and let them create the file their tool expects.

## 4. Report
State which adapter file(s) were created/appended/skipped (Claude Code) or which
snippet was printed for manual setup (other tools).
