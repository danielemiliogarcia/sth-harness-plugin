---
name: harness-interview
description: Shared one-question-at-a-time interview logic for filling harness project.md and feature spec/state files. Used by /sth-harness:init and /sth-harness:add-spec.
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

## Filling project.md
For each `<!-- CUSTOMIZE -->` block, ask for: what the project is, who it's for, goals/non-goals, code location, build/run/test/lint commands, tech stack, glossary. Replace each placeholder; never leave a CUSTOMIZE marker behind.

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

