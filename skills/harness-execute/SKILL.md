---
name: harness-execute
description: Role-driven execution loop that works one harness feature through its phases until blocked, a decision is needed, or the spec is done. Used by /sth-harness:execute-next-spec.
---

# Harness Execute

Drive one feature through the harness lifecycle, honoring minimal-context reading and durable state.

## Boot
1. Read `ai-harness/START-HERE.md` once (if not already read this session).
2. For the chosen feature, read `ai-harness/specs/<feature>/state.md`: phase, next action, read budget, tasks.
3. Open only what the read budget lists (usually one section of `spec.md`).
4. Adopt the role for the current phase from `ai-harness/roles.md` (read only that role's section).

## Loop (stop conditions are mandatory)
Run task by task. For an implementation task:
1. Set the task `doing` in `state.md`.
2. TDD where practical (red -> green -> refactor) per `ai-harness/context/testing.md`; if deferred, follow the DV plan and add a follow-up task.
3. Keep the domain pure; reach outside only through ports/adapters per `ai-harness/context/architecture.md`.
4. Move the task to `review`, then `done` once its validation passes.
5. Update `state.md` after every task.

STOP and hand back when ANY of:
- a blocker appears (set the task `blocked`, record blocker + what would unblock, set overall `blocked`);
- a decision genuinely needs the human (surface it clearly);
- the spec is `done` (all tasks `done`/`cancelled`, requirements satisfied, validation run or scheduled).

## Before stopping
Update `state.md` (phase, last completed step, next action, task states). Report the stop reason and the single next action. The file is the truth — never rely on conversation memory.

