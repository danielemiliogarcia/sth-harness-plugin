---
name: sth-harness
description: Codex entry point for installing ai-harness, adding feature specs, and executing the next pending spec without Claude slash commands.
---

# sth-harness

Use this skill when the user asks Codex to initialize the ai-harness, add a new
feature spec, or execute the next pending spec.

## Resolve bundled files

- This skill lives at `skills/sth-harness/SKILL.md`.
- The plugin root is two directories above this file.
- Bundled scripts live under `../../scripts/` from this skill directory.
- The bundled harness template lives under `../../template/ai-harness/`.
- In Claude Code, `CLAUDE_PLUGIN_ROOT` may also point at the plugin root, but
  do not require it in Codex.

## Intent routing

- `init`, `initialize`, `bootstrap`, or "install the harness" -> run Init.
- `add spec`, `new spec`, or "create a feature" -> run Add Spec.
- `execute`, `next spec`, or "continue harness work" -> run Execute Next Spec.
- If the user's wording is ambiguous, ask one short clarifying question.

## Init

Bootstrap the AI harness into the user's repository, then create the first
feature. Use the `harness-interview` skill for all question-asking.

### Preconditions

- If `./ai-harness/` already exists, stop. Tell the user the harness is already
  installed and suggest adding a spec instead. Do not overwrite.

### Steps

1. Install the harness folder verbatim by running the bundled
   `scripts/copy-harness.sh` with the current repository as its argument.
   Confirm exit 0 and that `./ai-harness/START-HERE.md` now exists. On non-zero
   exit, report the script's stderr and stop.
2. Fill `./ai-harness/context/project.md` via the `harness-interview` skill:
   detect and link existing docs, assess whether the README is rich enough,
   interview for gaps, set the app type, and offer to seed a README with the
   bundled `scripts/seed-readme.sh` only when no README exists. Replace every
   `<!-- CUSTOMIZE -->`; link, do not duplicate.
3. Wire the user's AI tool to the harness using the `harness-tool-linking` skill.
   For Codex, run the bundled `scripts/link-codex.sh` so Codex reads
   `AGENTS.md` -> `ai-harness/START-HERE.md`.
4. Create the first feature:
   - Read `./ai-harness/specs/global-spec-info.md` and
     `./ai-harness/specs/global-state-info.md` for exact fields and legal
     vocabulary.
   - Interview for feature name, one-line intent, requirements, acceptance or
     deferred validations, hexagonal design, and initial tasks.
   - Copy `ai-harness/specs/_template/` to `ai-harness/specs/<feature>/`.
   - Fill `spec.md` and `state.md` from the answers, using the legal vocabulary
     verbatim. Set `phase`, `overall: todo`, and a concrete `next`.
5. Report what was created and tell the user they can ask Codex to execute the
   next pending spec when ready.

Ask one question at a time. Never invent requirements; ask or record an open
question. The harness reference files are the source of truth.

## Add Spec

Add a new feature to an already-initialized harness. Use the `harness-interview`
skill for question-asking.

### Preconditions

- If `./ai-harness/` does not exist, stop. Tell the user to initialize the
  harness first.

### Steps

1. Read `./ai-harness/specs/global-spec-info.md` and
   `./ai-harness/specs/global-state-info.md` for fields and legal vocabulary.
2. Interview one question at a time: feature name, one-line intent, functional
   requirements, acceptance tests or deferred validations, hexagonal design, and
   initial tasks.
3. If `ai-harness/specs/<feature>/` already exists, stop and ask for a different
   name.
4. Copy `ai-harness/specs/_template/` to `ai-harness/specs/<feature>/`.
5. Fill `spec.md` and `state.md` from the answers, using legal vocabulary
   verbatim. Set `phase` to the furthest-completed phase, `overall: todo`, and a
   concrete `next`.
6. Check that every requirement maps to an acceptance test or deferred
   validation. If there is a gap, ask.
7. Report the files created.

Write only inside `ai-harness/specs/<feature>/` on the current branch. Do not run
git commands.

## Execute Next Spec

Work the next pending feature following the harness. Use the `harness-execute`
skill for the execution loop.

### Preconditions

- If `./ai-harness/` does not exist, stop. Tell the user to initialize the
  harness first.

### Steps

1. Scan every `ai-harness/specs/*/state.md`, skipping `_template`. Read each
   header: feature, phase, and overall state. A spec is pending unless its
   overall state is `done` or `cancelled`.
2. If none are pending, report "all specs done" and stop.
3. Rank pending specs by overall state: `blocked` > `review` > `doing` > `todo`.
   To break a tie at the top, read only the tied specs' `spec.md` and prefer the
   one whose highest-priority requirement is greatest: `must` > `should` >
   `could`. If still tied, present the tied specs and let the user pick.
4. For the chosen feature, follow the `harness-execute` skill: act as Session
   Loader, then adopt the role for the current phase from `ai-harness/roles.md`.
   Read only that role's section and honor the feature's `state.md` read budget.
5. Work the harness loop for the phase. During implementation, set the task
   `doing`, follow TDD where practical, keep the domain pure, and update
   `state.md` after each task.
6. Continue task by task until there is a blocker, a decision needs the human, or
   the spec is done.
7. Update `state.md` before stopping. Report the stop reason and the next action.

Read only the chosen feature's folder plus the shared context files needed for
the current step. Do not touch other features.
