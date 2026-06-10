# Specs

One subfolder per feature — heart of Specification-Driven Development. Each feature owns all its files, making parallel work conflict-free (see [`../parallel-work.md`](../parallel-work.md)).

```text
specs/
├── README.md            ← you are here
├── global-spec-info.md  ← static reference: how to fill any spec.md (read on demand)
├── global-state-info.md ← static reference: how to fill any state.md (read on demand)
├── _template/           ← copy this whole folder to start a feature
│   ├── spec.md          ←   bare freeform; structure/guidance in global-spec-info.md
│   └── state.md         ←   bare freeform; structure/guidance in global-state-info.md
└── <feature-name>/      ← one folder per feature (e.g. order-submission/)
    ├── spec.md
    └── state.md
```

---

## Two files per feature, on purpose

| File | Volatility | Holds |
|------|------------|-------|
| `spec.md` | **stable** — changes slowly | requirements (`REQ-*`), acceptance & validation (`AT-*` / `DV-*`), hexagonal design |
| `state.md` | **volatile** — changes every session | phase, next action, blocker, read budget, feature's task table (`T-*`) |

Splitting stable from volatile means routine task-state churn never rewrites spec — even edits to same feature merge cleanly. `state.md` is what fresh session reads first; `spec.md` sections opened on demand per phase.

Both per-feature files are **bare freeform key:value** — only filled-in content. Structure, legal vocabulary, how-to-fill guidance live in two shared static references (read on demand like `context/*`): [`global-spec-info.md`](global-spec-info.md) and [`global-state-info.md`](global-state-info.md).

---

## Start new feature

1. **Copy whole `_template/` folder** to `specs/<feature-name>/` (short, kebab-case, e.g. `order-submission`). On feature branch/worktree.
2. Fill `spec.md` § Requirements first (Spec Author). Give each requirement an ID.
3. Set `state.md`: phase = `requirements`, next action = "write acceptance tests", branch name recorded.
4. Proceed through lifecycle, updating `state.md` at each handoff.

> **One feature per branch.** Agent works in one feature folder — how multiple agents stay out of each other's way.

---

## Naming and IDs

- Folder: kebab-case feature name (`user-login/`, `order-submission/`).
- IDs **scoped to feature** — no global counter:
  - Requirements: `REQ-1`, `REQ-2`, … (stable within feature; never renumber once cited).
  - Acceptance tests: `AT-1`, …; deferred validations: `DV-1`, ….
  - Tasks: `T-1`, `T-2`, ….
- Cite across features with folder name: `order-submission/REQ-2`, `user-login/T-3`.

Two parallel branches can never collide on same ID.

---

## Finished features

When feature is `done`, leave folder in place with `state.md` marked `done` — it's feature's permanent record. See all work: `ls specs/` and read each `state.md` header. No global dashboard file (shared merge hotspot — see [`../parallel-work.md`](../parallel-work.md)).

---

## When feature gets large

If `spec.md` grows unwieldy, split heavy section into sibling file inside same folder (e.g. `design.md`) and link from `spec.md`. Keep `state.md` and lighter sections intact so resumability unaffected. Prefer staying in two files until size genuinely hurts.

---

## Lifecycle reminder

```text
idea → requirements → validation → design → tasks → implementation → review → done
```

Feature is `done` when all tasks are `done` (or `cancelled`), requirements satisfied, validation run or scheduled via follow-up tasks. Record completion in feature's `state.md`.
