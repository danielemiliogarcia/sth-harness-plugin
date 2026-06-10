---
description: Pick the next pending spec and implement it through the harness until blocked or done.
---

# /sth-harness:implement-next-spec

Implement the next pending feature following the harness. Use the `harness-implement` skill for the implementation loop.

## Preconditions
- If `./ai-harness/` does NOT exist, STOP. Tell the user to run `/sth-harness:init` first.

## Steps
1. Scan every `ai-harness/specs/*/state.md` (skip `_template`). Read each header: feature, phase, overall state. A spec is pending unless its overall state is `done` or `cancelled`.
2. If none are pending, report "all specs done" and STOP.
3. Rank pending specs by overall state: `blocked` > `review` > `doing` > `todo`. To break a tie at the top, read ONLY the tied specs' `spec.md` and prefer the one whose highest-priority requirement is greatest (`must` > `should` > `could`) — priority lives on the `REQ-*` lines in `spec.md`, not in `state.md`. If still tied, present the tied specs and let the user pick. Propose the top pick and ask the user to confirm or choose another.
4. For the chosen feature, follow the `harness-implement` skill: act as Session Loader, then adopt the role for the current phase (read only that role's section of `ai-harness/roles.md`). Honor the feature's `state.md` read budget.
5. Work the harness loop for the phase. During implementation: set the task `doing`, follow TDD where practical per `ai-harness/context/testing.md`, keep the domain pure per `ai-harness/context/architecture.md`, update `state.md` after each task.
6. Continue task by task UNTIL one of: a blocker (record it, set the task `blocked`, overall `blocked`), a decision needing the human (surface it), or the spec is `done`.
7. Update `state.md` before stopping (phase, last step, next action, task states). Report the stop reason and the next action.

Read only the chosen feature's folder plus the shared context files the step needs. Do not touch other features.
