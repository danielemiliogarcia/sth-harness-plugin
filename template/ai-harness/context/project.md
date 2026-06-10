# Project Context

> **`<!-- CUSTOMIZE -->` Most project-specific file in harness.**
> Replace placeholder content with real info about *this* project. Keep short — read often. Aim for one screen.

Stable, high-level facts about project that don't belong to any single feature: what it is, what it's for, where things live. Part of minimal context a session may load.

---

## Reference documents

> **Link authoritative docs; don't duplicate.** `project.md` is thin context hub — few stable facts plus pointers. Keep small (shared-static; see [`../parallel-work.md`](../parallel-work.md)).

<!-- CUSTOMIZE -->
- Root [`README.md`](../../README.md) — _one line on what it covers._
- _Architecture/design docs, ADRs, API specs, … as they exist._

> If root `README.md` is thin, either enrich it, link more docs above, or capture missing facts below.

## What this project is

<!-- CUSTOMIZE -->
_One or two sentences: product/system and problem it solves._

Example: "Service that ingests orders, validates against inventory, emits fulfilment events."

**Application type:** <!-- CUSTOMIZE --> _frontend | backend | fullstack | CLI | library | mobile | other._

## Who it is for

<!-- CUSTOMIZE -->
_Primary users/stakeholders and what they need._

## Goals and non-goals

<!-- CUSTOMIZE -->
- **Goals:** _what success looks like._
- **Non-goals:** _things explicitly out of scope, to prevent drift._

## Where code lives

<!-- CUSTOMIZE -->
_Document application source layout so every tool learns it from harness. Harness lives in `ai-harness/`; app lives elsewhere (e.g. `src/`)._

```text
.
├── ai-harness/        # this harness (process, specs, tasks, state)
├── src/               # <!-- CUSTOMIZE --> application source
│   ├── domain/        # pure business rules — no IO, no frameworks
│   ├── application/   # use cases + port interfaces
│   └── adapters/      # implementations of ports (db, http, cli, …)
└── tests/             # <!-- CUSTOMIZE --> automated tests
```

## How to build, run, and test

<!-- CUSTOMIZE -->
_Exact commands agent should use. Fill in once stack is chosen._

```text
build:  <command>
run:    <command>
test:   <command>
lint:   <command>
```

## Tech stack and key constraints

<!-- CUSTOMIZE -->
- Language / runtime: _…_
- Frameworks / libraries: _…_
- External systems (DB, queues, APIs): _…_
- Hard constraints (compliance, performance budgets, platforms): _…_

## Glossary (domain language)

<!-- CUSTOMIZE -->
_Define ubiquitous language so specs and code use same words._

> **Parallel-safety:** glossary is shared. Term introduced by one feature goes in that feature's `spec.md` first; promote here deliberately on main branch (so parallel feature branches don't conflict appending terms). See [`../parallel-work.md`](../parallel-work.md).

| Term | Meaning |
|------|---------|
| _Order_ | _…_ |
| _Inventory_ | _…_ |

---

Until customized, treat unknown items here as **open questions** and confirm with human rather than assuming.
