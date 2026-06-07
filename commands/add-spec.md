---
description: Interview for a new feature and create its spec.md + state.md in an initialized repo.
argument-hint: "[feature-name]"
---

# /sth-harness:add-spec

Add a new feature to an already-initialized harness. Use the `harness-interview` skill for question-asking.

## Preconditions
- If `./ai-harness/` does NOT exist, STOP. Tell the user to run `/sth-harness:init` first.

## Steps
1. Read `./ai-harness/specs/global-spec-info.md` and `./ai-harness/specs/global-state-info.md` for the fields and legal vocabulary.
2. Interview ONE question at a time: feature name (kebab-case; if an argument was given, propose it), one-line intent, functional requirements (each `REQ-n (priority)` with priority must/should/could), acceptance tests (`AT-n` Given/When/Then; mark write-first "red") or deferred validations (`DV-n` with reason + interim check + follow-up task), hexagonal design (domain / ports / adapters / usecases / feature-local conventions), and initial tasks (`T-n <state> <title> (REQ-x, AT-y)`).
3. If `ai-harness/specs/<feature>/` already exists, STOP and ask for a different name.
4. Copy `ai-harness/specs/_template/` to `ai-harness/specs/<feature>/`.
5. Fill the bare `spec.md` and `state.md` from the answers, using legal vocabulary verbatim. Set `phase` to the furthest-completed phase (`tasks` if tasks were defined, else `requirements`), `overall: todo`, and a concrete `next`.
6. Coverage check: every REQ maps to an AT or DV. If a gap, ask.
7. Report the files created.

Writes only inside `ai-harness/specs/<feature>/` on the current branch. No git commands.

--- END FILE ---
