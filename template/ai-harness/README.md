# AI Harness

**Model- and provider-agnostic** development harness, built entirely from folders and Markdown. Any AI coding assistant that reads repo files can follow it — Claude Code, Codex, GitHub Copilot, Pi, OpenCode, Gemini CLI, Aider, future agents. Nothing inside `ai-harness/` depends on specific model, vendor, plugin, or runtime tool.

> **New session?** Don't start here — start at [`START-HERE.md`](START-HERE.md). This README explains how harness works; read it once.

Six ideas combined into one lightweight, repo-local process:

- **Specification-Driven Development (SDD)** — write requirements before code.
- **Test-Driven Development (TDD)** — prove behavior first *when practical*.
- **Hexagonal Architecture (Ports & Adapters)** — keep domain independent.
- **Persistent task state** — every task has explicit, durable status.
- **Fresh-session resumability** — new agent resumes from few small files.
- **Minimal context loading** — read only what current step needs.

Also **parallel-safe**: each feature owns all mutable state in its own folder — multiple agents build different features in separate branches/worktrees without merge conflicts. See [`parallel-work.md`](parallel-work.md).

> `ai-harness/` is separate from application source code. Harness describes *how* you work; build app wherever (e.g. top-level `src/`). Keep them apart.

---

## What to read for a given goal

| Your goal | Read |
|-----------|------|
| Resume work right now | `specs/<your-feature>/state.md` (via [`START-HERE.md`](START-HERE.md)) |
| Understand boot sequence | [`START-HERE.md`](START-HERE.md) |
| Run several agents in parallel | [`parallel-work.md`](parallel-work.md) |
| Know responsibilities of each role | [`roles.md`](roles.md) |
| Learn architecture rules (hexagonal) | [`context/architecture.md`](context/architecture.md) |
| Learn testing/validation approach | [`context/testing.md`](context/testing.md) |
| Learn project-specific facts | [`context/project.md`](context/project.md) |
| Start or shape a feature | [`specs/README.md`](specs/README.md) |
| Record significant decision | [`decisions/README.md`](decisions/README.md) |
| Connect a specific AI tool | [`tool-linking.md`](tool-linking.md) |

---

## The lifecycle

```text
idea → requirements → validation → design → tasks → implementation → review → done
```

| Phase | Question answered | Where it lives | Role |
|-------|-------------------|----------------|------|
| idea | Is this worth doing? | a new `specs/<feature>/` folder | Planner |
| requirements | What and why? | `specs/<feature>/spec.md` § Requirements | Spec Author |
| validation | How will we know it works? | `specs/<feature>/spec.md` § Acceptance & Validation | Tester |
| design | How is it built? | `specs/<feature>/spec.md` § Design (hexagonal) | Spec Author |
| tasks | What are the steps? | `specs/<feature>/state.md` § Tasks | Planner |
| implementation | Build it | your app code + task state in `state.md` | Implementer |
| review | Does it meet the spec? | review notes + state → `done` | Reviewer |
| done | Record and close | `specs/<feature>/state.md` marked `done` | Planner |

Phases are default order, not a cage. Tiny change may collapse several phases; large feature iterates (design often loops back to requirements). Rule that matters: **artifact for a phase must exist before you rely on it.** Spec before code; validation defined before implementation when practical.

---

## The rules (read once, then follow)

1. **Spec before code.** No implementation task starts without written requirements it can cite.
2. **Validation before implementation when practical.** Define acceptance tests or scenarios first. If deferred, **write down why** and define future validation path — never skip silently.
3. **TDD preferred, not mandatory.** Exploratory, infrastructure-heavy, or hard-to-test work may design validation first and automate later (see [`context/testing.md`](context/testing.md)).
4. **Keep domain pure.** Business logic never imports frameworks, databases, HTTP, or UI. External systems reached through **ports**; **adapters** implement them. See [`context/architecture.md`](context/architecture.md).
5. **Every task has explicit state:** `todo`, `doing`, `blocked`, `review`, `done`, or `cancelled`.
6. **State is durable and feature-local.** Truth lives in `specs/<feature>/state.md`, not conversation memory. Update it; never rely on what previous session "remembered".
7. **Load minimum context.** Read what step needs and no more; feature's `state.md` read budget tells you what is enough.
8. **One feature per branch; write only your feature folder.** Keeps parallel work conflict-free (see [`parallel-work.md`](parallel-work.md)).
9. **Leave campsite ready.** Update `specs/<feature>/state.md` before stopping so next session resumes without rediscovery.

---

## The state model

Every task is in exactly one state:

| State | Meaning | Typical next state |
|-------|---------|--------------------|
| `todo` | Defined, not started | `doing` |
| `doing` | Actively being worked | `review` or `blocked` |
| `blocked` | Cannot proceed; reason recorded | `doing` or `cancelled` |
| `review` | Implementation done, awaiting verification | `done` or `doing` |
| `done` | Meets requirements and validation | — |
| `cancelled` | Will not be done; reason recorded | — |

- `blocked` task **must** record blocker and what would unblock it.
- Task moves to `review` only when done-criteria met **and** validation run or explicitly scheduled.
- Task moves to `done` only after review confirms requirements + validation.
- **Source of truth for task state is `specs/<feature>/state.md`.** No global board.

---

## Where state lives (and why it is small)

No global mutable state files. Instead:

- **`specs/<feature>/state.md`** — *now* for one feature: phase, next action, read budget, task table. First thing a session reads.
- **`specs/<feature>/spec.md`** — stable spec: requirements, validation, design. Changes slowly.
- **`decisions/YYYY-MM-DD-slug.md`** — one self-contained file per cross-cutting decision; directory listing is the index.

Each feature folder written by exactly one branch at a time — harness files always merge cleanly. Full rationale and worktree workflow in [`parallel-work.md`](parallel-work.md).

---

## Traceability

Requirements, validation, and tasks cite each other by IDs **scoped to the feature** (no global counter) — reviewer can confirm coverage without reading whole codebase:

```text
requirement (REQ-3) ── satisfied by ──> task (T-7) ── proven by ──> acceptance test (AT-3)
                                                     └─ or deferred ─> validation plan (DV-1)
```

- Requirements: `REQ-1`, `REQ-2`, … (stable within feature; never renumber once cited).
- Acceptance tests: `AT-1`, …; deferred validations: `DV-1`, ….
- Tasks: `T-1`, `T-2`, … (per feature). Cite across features as `<feature>/T-1`, `<feature>/REQ-2`.

---

## Folder map

```text
ai-harness/
├── START-HERE.md       ← boot sequence (read first, every session)
├── README.md           ← you are here: how the harness works
├── parallel-work.md    ← file ownership + worktree workflow + merge rules
├── tool-linking.md     ← connect any AI tool via a thin adapter
├── roles.md            ← the "hats" an agent wears per phase (all roles, one file)
├── context/            ← stable, shared project knowledge (read-only mid-feature)
│   ├── project.md      ← project-specific facts (CUSTOMIZE)
│   ├── architecture.md ← hexagonal (ports & adapters) rulebook
│   └── testing.md      ← validation strategy: TDD-when-practical + deferral
├── specs/              ← one FOLDER per feature (the heart of SDD)
│   ├── README.md       ← how the feature-folder model works + naming
│   ├── global-spec-info.md   ← static reference: how to fill any spec.md
│   ├── global-state-info.md  ← static reference: how to fill any state.md
│   ├── _template/      ← copy this whole folder to start a feature
│   │   ├── spec.md     ← bare freeform (guidance in global-spec-info.md)
│   │   └── state.md    ← bare freeform (guidance in global-state-info.md)
│   └── <feature>/      ← e.g. order-submission/  (spec.md + state.md)
└── decisions/          ← architecture decision records (ADRs)
    ├── README.md       ← when/how to write one (no index — dir is the index)
    └── 2026-06-07-adopt-ai-harness.md
```

