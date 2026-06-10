# Global State Info — how to fill any feature's `state.md`

**Shared, static reference. Read on demand (like `context/*`); don't copy into feature.** Defines structure, legal vocabulary, and rules for every `specs/<feature>/state.md`. Each feature's `state.md` is **bare freeform key:value** — only live values. All the *how* lives here.

> **Parallel-safety:** shared static. Treat read-only during feature work; edit deliberately on main branch. See [`../parallel-work.md`](../parallel-work.md).

---

## What `state.md` is

**Volatile** live anchor for one feature: *now*, *next action*, *read budget*, *task table*. Fresh session reads it right after identifying feature. **Update before ending every session** — if writing only one file before stopping, make it this one.

Lives inside feature folder — parallel agents on different features never touch same `state.md` → no merge conflicts.

---

## Legal vocabulary (don't drift — freeform has no schema to catch you)

**Phase** (exactly one):

```
requirements | validation | design | tasks | implementation | review | done
```

**Overall state** and **task state** (exactly one of):

| State | Meaning | Typical next |
|-------|---------|--------------|
| `todo` | defined, not started | `doing` |
| `doing` | actively worked | `review` or `blocked` |
| `blocked` | cannot proceed; reason recorded | `doing` or `cancelled` |
| `review` | implementation done, awaiting verification | `done` or `doing` |
| `done` | meets requirements + validation | — |
| `cancelled` | will not be done; reason recorded | — |

Rules:
- Prefer **exactly one `doing`** task at a time.
- `blocked` task **must** record blocker and what would unblock it.
- `review` → `done` only after validation run or explicitly scheduled.
- Task/requirement IDs **scoped per feature** (`T-1`, `REQ-1`); cite across features as `<feature>/T-1`.

---

## Fields

- `feature`, `branch` — identity (branch usually matches folder name).
- `phase` — one of phases above.
- `overall` — one of states above (`blocked` if any blocker set).
- `updated` — `YYYY-MM-DD`.
- `last step` — one line, what was just completed.
- `next` — single most useful next action, concrete enough to start now.
- `blocker` — `none`, or blocker + what would unblock it.
- `read budget` — what to read now / on demand / skip (keeps context minimal).
- `tasks` — feature's task list (source of truth for task state).
- `watch-outs` — anything non-obvious for next session.

### Task-line convention (anti-drift)

One line per task:

```
T-<n> <state> <title> (REQ-<x>, AT-<y> | DV-<z>)
```

Expand the one task in `doing` with sub-detail (steps, done-criteria, validation plan) underneath when useful.

---

## Canonical freeform shape (worked example)

```
# state: order-submission
feature: order-submission
branch: feat/order-submission
phase: implementation
overall: doing
updated: 2026-06-07

last step: Order domain done, AT-1 green
next: write SqlOrderRepository to satisfy AT-2 (T-2)
blocker: none

read budget:
  now: ../../START-HERE.md (if unread) · this file · spec.md design section
  on demand: ../../context/architecture.md · cited ../../decisions/*
  skip: other features · whole context/

tasks:
  T-1 done  Order domain + invariant (REQ-1, AT-1)
  T-2 doing SqlOrderRepository       (REQ-2, AT-2)
  T-3 todo  HttpOrderController      (REQ-2, AT-2)

watch-outs:
  - SubmitOrder wiring lives in the composition root; keep it thin
```
