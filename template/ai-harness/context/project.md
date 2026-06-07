# Project Context

> **`<!-- CUSTOMIZE -->` This is the most project-specific file in the harness.**
> Replace the placeholder content below with real information about *this*
> project. Keep it short — it is read often. Aim for one screen.

This file gives an agent the stable, high-level facts about the project that do
not belong to any single feature: what it is, what it is for, and where things
live. It is part of the minimal context a session may load.

---

## Reference documents

> **Link the authoritative docs; don't duplicate them here.** `project.md` is a
> thin context hub — a few stable facts plus pointers. Keep it small (it is
> shared-static; see [`../parallel-work.md`](../parallel-work.md)).

<!-- CUSTOMIZE -->
- Root [`README.md`](../../README.md) — _one line on what it covers._
- _Architecture / design docs, ADRs, API specs, … as they exist._

> If the root `README.md` is thin, either enrich it, link more docs above, or
> capture the missing facts in the sections below.

## What this project is

<!-- CUSTOMIZE -->
_One or two sentences: the product/system and the problem it solves._

Example: "A service that ingests orders, validates them against inventory, and
emits fulfilment events."

**Application type:** <!-- CUSTOMIZE --> _frontend | backend | fullstack | CLI |
library | mobile | other._

## Who it is for

<!-- CUSTOMIZE -->
_Primary users / stakeholders and what they need from it._

## Goals and non-goals

<!-- CUSTOMIZE -->
- **Goals:** _what success looks like._
- **Non-goals:** _things explicitly out of scope, to prevent drift._

## Where the code lives

<!-- CUSTOMIZE -->
_Document the application source layout so every tool learns it from the harness.
The harness lives in `ai-harness/`; the app lives elsewhere (e.g. `src/`)._

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
_The exact commands an agent should use. Fill these in once the stack is chosen._

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
_Define the ubiquitous language so specs and code use the same words._

> **Parallel-safety:** this glossary is shared. A term introduced by one feature
> goes in that feature's `spec.md` first; promote it here deliberately on the main
> branch (so parallel feature branches don't conflict appending terms). See
> [`../parallel-work.md`](../parallel-work.md).

| Term | Meaning |
|------|---------|
| _Order_ | _…_ |
| _Inventory_ | _…_ |

---

Until customized, treat unknown items here as **open questions** and confirm with
the human rather than assuming.
