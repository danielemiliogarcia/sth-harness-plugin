---
description: Install the ai-harness into this repo, then interview to fill project.md and the first spec.
argument-hint: "[feature-name]"
---

# /sth-harness:init

Bootstrap the AI harness into the user's repository, then create the first feature. Use the `harness-interview` skill for all question-asking.

## Preconditions
- If `./ai-harness/` already exists, STOP. Tell the user the harness is already installed and suggest `/sth-harness:add-spec`. Do NOT overwrite.

## Steps
1. Install the harness folder verbatim:
   `bash "${CLAUDE_PLUGIN_ROOT}/scripts/copy-harness.sh" "$PWD"`
   Confirm exit 0 and that `./ai-harness/START-HERE.md` now exists. On non-zero exit, report the script's stderr and stop.
2. Fill `./ai-harness/context/project.md` via the `harness-interview` skill: detect and link existing docs (assess the README's richness — if thin, say so and link more docs or run the fuller interview), set the app-type, and if no README exists offer to seed one with `scripts/seed-readme.sh`. Replace every `<!-- CUSTOMIZE -->` in `project.md`, including inline comments in examples; link, don't duplicate.
3. Wire the user's AI tool to the harness — follow the `harness-tool-linking` skill: detect the tool (confirm with the user), then write the matching adapter(s). For Claude Code this creates/updates `AGENTS.md` and `CLAUDE.md` (which imports it via `@AGENTS.md`), so the tool bootstraps from `ai-harness/START-HERE.md`.
4. Create the FIRST feature:
   - Read `./ai-harness/specs/global-spec-info.md` and `./ai-harness/specs/global-state-info.md` for the exact fields and legal vocabulary.
   - Interview for: feature name (kebab-case; if an argument was given, propose it), one-line intent, requirements (REQ-*), acceptance (AT-*/DV-*), hexagonal design, initial tasks (T-*).
   - Copy `ai-harness/specs/_template/` to `ai-harness/specs/<feature>/`.
   - Fill the bare `spec.md` and `state.md` from the answers, using the legal vocabulary verbatim. Set `phase`, `overall: todo`, and a concrete `next`.
5. Before finishing, re-read every file this init flow created or edited intentionally (`./ai-harness/context/project.md`, the first feature's `spec.md` and `state.md`, root adapter files, and a seeded README if one was created). If any actionable `<!-- CUSTOMIZE -->` placeholder remains, keep interviewing or fill from known facts until it is gone. Do not count documentation-only occurrences that merely explain the marker itself, such as this command file or copied harness docs like `ai-harness/README.md`, `ai-harness/context/testing.md`, `ai-harness/context/architecture.md`, or decision records.
6. Report what was created and tell the user to run `/sth-harness:implement-next-spec` when ready.

Ask one question at a time. Never invent requirements — ask or record an open question. The harness reference files are the source of truth for structure and vocabulary.
