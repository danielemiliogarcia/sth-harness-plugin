---
description: Pick the next pending spec and work it through the harness until blocked or done.
---

# /sth-harness:execute-next-spec

Work the next pending feature following the harness. Use the `harness-execute` skill for the execution loop.

## Preconditions
- If `./ai-harness/` does NOT exist, STOP. Tell the user to run `/sth-harness:init` first.

## Steps
1. Scan every `ai-harness/specs/*/state.md` (skip `_template`). Read each header: feature, phase, overall state.
2. If none are pending (all `done`/`cancelled`), report "all specs done" and STOP.
3. Rank pending specs: `blocked` > `review` > `doing` > `todo`; tie-break by highest task priority (`must` > `should` > `could`). Propose the top pick and ask the user to confirm or choose another.
4. For the chosen feature, follow the `harness-execute` skill: act as Session Loader, then adopt the role for the current phase (read only that role's section of `ai-harness/roles.md`). Honor the feature's `state.md` read budget.
5. Work the harness loop for the phase. During implementation: set the task `doing`, follow TDD where practical per `ai-harness/context/testing.md`, keep the domain pure per `ai-harness/context/architecture.md`, update `state.md` after each task.
6. Continue task by task UNTIL one of: a blocker (record it, set the task `blocked`, overall `blocked`), a decision needing the human (surface it), or the spec is `done`.
7. Update `state.md` before stopping (phase, last step, next action, task states). Report the stop reason and the next action.

Read only the chosen feature's folder plus the shared context files the step needs. Do not touch other features.

--- END FILE ---
