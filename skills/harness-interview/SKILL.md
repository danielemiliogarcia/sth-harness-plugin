---
name: harness-interview
description: Shared one-question-at-a-time interview logic for filling harness project.md and feature spec/state files. Used by /sth-harness:init, /sth-harness:add-spec, and the Codex sth-harness skill.
---

# Harness Interview

Turn a user's intent into filled harness files by asking ONE question at a time.

## Principles
- One question per message; prefer bounded multiple-choice when options are finite.
- The harness's own reference files are the schema. Before asking, read:
  - `ai-harness/specs/global-spec-info.md` — spec fields, ID rules, coverage rule.
  - `ai-harness/specs/global-state-info.md` — state fields, legal phases + task states, task-line format.
- Never invent requirements, acceptance, or design. If the user is unsure, offer options or record an open question.
- Map answers 1:1 onto the bare freeform fields. Keep per-feature files short — guidance lives in the global references, not in the feature files.

## Filling project.md (system context)
`project.md` is the system-context hub. Fill it as follows:

1. **Detect existing docs.** Look for a root `README.md` and common docs
   (`docs/`, `ARCHITECTURE.md`, `CONTRIBUTING.md`).
2. **Assess the README.** Does it describe what the project is, its goal, the
   tech, and the structure?
   - **Rich enough** -> link it (and the other docs) under *Reference documents*
     in `project.md`, then interview only for the gaps (build/run/test commands,
     app-type if unclear). Keep it light.
   - **Thin or missing key facts** -> tell the user the README is thin, and offer
     to either point you at more docs to link, or answer the fuller interview so
     `project.md` captures the missing facts directly.
3. **Set the app-type** (`frontend | backend | fullstack | CLI | library |
   mobile | other`) — ask if it cannot be derived from the docs.
4. **From-scratch (no README):** fill `project.md` from the interview, then
   **offer (ask first)** to seed a minimal README with the bundled
   `scripts/seed-readme.sh` (idempotent, never clobbers). In Codex, resolve it
   relative to the loaded plugin skill path; in Claude Code,
   `CLAUDE_PLUGIN_ROOT/scripts/seed-readme.sh` may be available.
5. Replace every `<!-- CUSTOMIZE -->` in `project.md`, including inline comments
   in examples; link, don't duplicate — keep `project.md` a small hub.
6. Before returning from project-context filling, re-read `project.md`. If any
   actionable `<!-- CUSTOMIZE -->` placeholder remains, ask a follow-up or fill
   it from known facts. Do not treat documentation-only occurrences elsewhere in
   the harness as project fields.

## Filling a feature (spec.md + state.md)
1. Feature name (kebab-case).
2. One-line intent.
3. Requirements: each testable/observable -> `REQ-n (priority): ...`.
4. Acceptance: one+ per REQ as Given/When/Then -> `AT-n covers REQ-x (level, red?)`; or a `DV-n` block (reason + interim check + follow-up task).
5. Coverage check: every REQ has an AT or DV.
6. Design: domain, ports (capability-named), adapters (driven/driving), usecases, feature-local conventions.
7. Tasks: `T-n <state> <title> (REQ-x, AT-y)`, outside-in slices, at most one `doing`.
8. Write the bare `spec.md` and `state.md`; set phase, overall, next.

## Validation
After writing, re-read both files: do they match the bare freeform shape? Do IDs cross-cite correctly? Is the legal vocabulary used verbatim?
