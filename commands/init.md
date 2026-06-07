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
2. Fill `./ai-harness/context/project.md`: for every `<!-- CUSTOMIZE -->` block, interview ONE question at a time (what the project is, who it's for, goals/non-goals, code location, build/run/test/lint commands, tech stack, glossary). Replace every placeholder; leave no CUSTOMIZE marker behind.
3. Offer (ask first) to create a root `AGENTS.md` adapter pointing to `ai-harness/START-HERE.md` (snippet in `ai-harness/tool-linking.md`). Create only on agreement.
4. Create the FIRST feature:
   - Read `./ai-harness/specs/global-spec-info.md` and `./ai-harness/specs/global-state-info.md` for the exact fields and legal vocabulary.
   - Interview for: feature name (kebab-case; if an argument was given, propose it), one-line intent, requirements (REQ-*), acceptance (AT-*/DV-*), hexagonal design, initial tasks (T-*).
   - Copy `ai-harness/specs/_template/` to `ai-harness/specs/<feature>/`.
   - Fill the bare `spec.md` and `state.md` from the answers, using the legal vocabulary verbatim. Set `phase`, `overall: todo`, and a concrete `next`.
5. Report what was created and tell the user to run `/sth-harness:execute-next-spec` when ready.

Ask one question at a time. Never invent requirements — ask or record an open question. The harness reference files are the source of truth for structure and vocabulary.

--- END FILE ---
