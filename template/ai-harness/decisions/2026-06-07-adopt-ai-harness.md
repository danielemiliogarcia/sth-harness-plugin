# Adopt the AI Harness (parallel-safe, feature-owned state)

- **Status:** accepted
- **Date:** 2026-06-07
- **Deciders:** project owner (with AI agent)
- **Related:** whole `ai-harness/` folder; [`../README.md`](../README.md); [`../parallel-work.md`](../parallel-work.md)

---

## Context

Project developed largely with AI coding assistants, possibly several at once and different ones over time (Claude Code, Codex, Copilot, Pi, OpenCode, Gemini CLI, Aider, future tools). Need a way of working that:

- writes specifications and validation before implementation;
- keeps domain independent of infrastructure (hexagonal architecture);
- tracks task state durably so progress not lost between sessions;
- lets brand-new AI session resume after reading only few small files;
- **lets multiple agents work on different features in parallel (separate branches/git worktrees) and merge back to main without conflicts;**
- does not bind to any single model, provider, plugin, or runtime tool;
- stays simple — folders and Markdown, no scripts or CI to maintain.

## Decision

Adopt single, self-contained, Markdown-only harness under `ai-harness/`. Encodes Specification-Driven Development, Test-Driven Development (preferred not mandatory), hexagonal architecture, explicit task state, fresh-session resume protocol anchored by `START-HERE.md`.

Defining structural rule is **feature-owned state**: each feature is folder under `specs/<feature>/` containing `spec.md` (stable: requirements, validation, design) and `state.md` (volatile: phase, next action, read budget, task table). **No global mutable state files** — no single "current task" pointer, no shared task board, no decision index. Fresh session finds feature from branch/worktree it is in and reads that feature's `state.md`.

Consequences for IDs and decisions, also for parallel safety:

- Task/requirement IDs **scoped per feature** (`T-1`, `REQ-1`), so no two branches collide on ID.
- ADRs **date-named** (`YYYY-MM-DD-slug.md`) with **no index file**; directory listing is index.
- Feature-specific ports/terms/conventions live in feature's `spec.md`, not shared `context/*`; project-wide promotion happens deliberately on main.

Tool-specific integration optional, via thin adapter files at repo root pointing to `ai-harness/START-HERE.md` (see [`../tool-linking.md`](../tool-linking.md)); none created by default.

## Alternatives considered

- **Global state files (one `current.md` pointer + one shared task board + sequential ADR numbering).** — Rejected: every parallel branch writes same files, causing merge conflicts and duplicate IDs. No single "now" when N agents work at once. Earlier draft of this harness; parallel requirement ruled it out.
- **One combined Markdown file per feature (spec + state in one file).** — Rejected: routine task-state churn would rewrite spec, creating needless intra-feature merge friction. Splitting stable `spec.md` from volatile `state.md` avoids it.
- **Committed cross-feature dashboard/index file.** — Rejected as default: any shared file every branch appends to becomes conflict hotspot. `ls specs/` plus per-feature `state.md` gives overview without shared mutable file.
- **Per-tool instruction files with real content (e.g. full `CLAUDE.md`).** — Rejected: duplicates guidance across tools and drifts out of sync.
- **Heavy tooling (scripts, CI, generators).** — Rejected for now: more to maintain, explicitly out of scope. Folders + Markdown only.

## Consequences

- Easier: consistent process across any AI tool; quick onboarding for fresh sessions; clear traceability from requirements → tasks → tests; **parallel feature development that merges cleanly.**
- Harder / obligations: no single-glance dashboard (use `ls specs/` + each `state.md`); discipline replaces automation — keep feature's `state.md` current, write only own feature folder during feature work.
- Application-code merges still ordinary merge work; harness only guarantees *harness* files merge cleanly (see [`../parallel-work.md`](../parallel-work.md)).
- Follow-up: customize `context/project.md` and other `<!-- CUSTOMIZE -->` sections once stack and first feature chosen.
