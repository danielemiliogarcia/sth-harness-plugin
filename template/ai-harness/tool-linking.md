# Tool Linking

Harness is **provider-agnostic**. Nothing inside `ai-harness/` depends on specific AI tool, model, or vendor. Any assistant that reads repo files can use it via:

```text
ai-harness/START-HERE.md
```

How to *optionally* connect specific tools to harness **without** making harness depend on them.

---

## Core idea: thin adapters, single source of truth

Most AI coding tools look for their own instruction file at repo root. Rather than duplicating guidance into each (drifts and rots), create **thin adapter**: tiny root file whose only job is to point tool at `ai-harness/START-HERE.md`.

```text
          AGENTS.md ─┐
          CLAUDE.md ─┤
 copilot-instructions ┤──►  "Read ai-harness/START-HERE.md and follow it."  ──►  ai-harness/
          PI.md ─────┤
        (others) ────┘
```

- Harness stays **single source of truth**.
- Each tool file is **3–6 lines** with no real content of its own.
- Adding/removing tool never touches harness.

> **Adapter files NOT created by default.** Harness ships as folders and Markdown inside `ai-harness/` only — no tool-specific files at repo root. Human creates adapter **only** for tools actually used, by copying a snippet below.

---

## How to add adapter (general pattern)

1. Find which instruction file your tool reads at startup (check its docs).
2. Create that file at location tool expects.
3. Put short pointer in it — nothing more. Example body:

   ```markdown
   # Project AI Instructions

   This repository uses a shared, tool-agnostic AI harness.

   **Read `ai-harness/START-HERE.md` first and follow its boot sequence.**
   It defines the workflow, the architecture rules, where the active task is,
   and what to update before ending a session. Do not duplicate guidance here;
   keep this file thin and let the harness be the single source of truth.
   ```

Entire pattern. Everything below is convenience snippets and notes.

---

## Known tool entry points (verify against current docs)

Tool conventions change. **Confirm exact filename/path in tool's current docs before relying.** Table reflects common conventions at time of writing — may be out of date.

| Tool | Common root file | Notes |
|------|---------------------------|-------|
| Many agents (shared convention) | `AGENTS.md` | Growing cross-tool convention; good default |
| Claude Code | `CLAUDE.md` | Also supports nested `CLAUDE.md` files |
| GitHub Copilot | `.github/copilot-instructions.md` | Repo-wide custom instructions |
| Codex | `AGENTS.md` (or tool-specific path) | Prefers shared `AGENTS.md` convention |
| Gemini CLI | `GEMINI.md` | Project context file |
| Pi | `PI.md` (or tool-specific) | Check tool's docs |
| OpenCode | tool-specific | Check tool's docs |
| Aider | `CONVENTIONS.md` (added as read-only context) | Point Aider at it explicitly |
| Cursor | `.cursorrules` (or project rules) | Check tool's docs |

If creating **one** adapter, make it `AGENTS.md` — most widely shared convention, several tools read it.

---

## Ready-to-copy adapter snippets

Each intentionally minimal. Replace nothing inside `ai-harness/`.

### `AGENTS.md` (recommended default)

```markdown
# Agent Instructions

This repository uses a tool-agnostic AI harness.
**Start by reading `ai-harness/START-HERE.md` and follow its boot sequence.**
You work one feature per branch; current work lives in
`ai-harness/specs/<your-feature>/state.md`.
Keep this file thin; the harness is the single source of truth.
```

### `CLAUDE.md`

```markdown
# Claude Code Instructions

Read `ai-harness/START-HERE.md` first and follow it.
Find current work in `ai-harness/specs/<your-feature>/state.md`.
Update that feature's state.md before ending the session (see START-HERE.md).
```

### `.github/copilot-instructions.md`

```markdown
# Copilot Instructions

This project is driven by a shared AI harness.
Read `ai-harness/START-HERE.md` and follow its rules and boot sequence.
Current work and next steps: `ai-harness/specs/<your-feature>/state.md`.
Keep the domain decoupled per `ai-harness/context/architecture.md`.
```

### `GEMINI.md`

```markdown
# Gemini Project Context

Read `ai-harness/START-HERE.md` first and follow it.
The active feature/task is in `ai-harness/specs/<your-feature>/state.md`.
```

### `PI.md`

```markdown
# Pi Agent Rules

Initialize every session by reading `ai-harness/START-HERE.md`.
Adopt the role for the current phase (`ai-harness/roles.md`), and keep task state
in your feature's `ai-harness/specs/<your-feature>/state.md`, updated before stopping.
```

### `CONVENTIONS.md` (Aider — point Aider at it)

```markdown
# Conventions

Follow the shared AI harness. Read `ai-harness/START-HERE.md` first.
Architecture rules: `ai-harness/context/architecture.md`.
Current work: `ai-harness/specs/<your-feature>/state.md`.
```

---

## Multiple tools, one harness

Keep several adapter files at once (e.g. `AGENTS.md` **and** `CLAUDE.md`). Because each only points to `ai-harness/START-HERE.md`, they can't drift apart. Change how you work → change harness → every tool follows automatically.

---

## What tool still needs from human

Harness tells agent *how to work*, but few things remain human's job per tool, in that tool's own config (not harness):

- **Permissions/sandbox settings** — what commands tool may run.
- **Model selection** — harness is indifferent; pick any capable model.
- **Where app source lives** — record in [`context/project.md`](context/project.md) so every tool learns it from harness.

Boundary: **how we work → harness; how this tool runs → tool config.**
