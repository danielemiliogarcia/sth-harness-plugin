# Decisions (ADRs)

Lightweight **Architecture Decision Records** for **cross-cutting** choices — ones that shape whole project or constrain future work. When future-you asks "why did we do it this way?", record it here as short, self-contained note.

```text
decisions/
├── README.md                    ← you are here (format + when)
└── YYYY-MM-DD-<slug>.md         ← one file per decision (date-named, self-sorting)
```

Worked example exists: [`2026-06-07-adopt-ai-harness.md`](2026-06-07-adopt-ai-harness.md).

> **Feature-local choices stay in feature.** Trade-off affecting only one feature belongs in that feature's `spec.md` § Design, not here. Reserve `decisions/` for genuinely project-wide choices.

Files named `YYYY-MM-DD-<slug>.md` — no sequential numbers, no index file. Directory listing sorted by name **is** the index.

---

## When to write one

Write ADR when you:

- choose architecture pattern, boundary, or major library;
- pick one approach over viable alternative with real trade-offs;
- adopt convention everyone must follow;
- make choice you might otherwise re-litigate later.

**Don't** write one for trivial or easily-reversed choices — keep signal high.

## How to write one

1. Create `YYYY-MM-DD-<short-slug>.md` (today's date).
2. Use format below. Keep to roughly one screen.
3. Set status to `accepted` (or `proposed` if still under discussion).
4. Link from relevant `spec.md` § Design or [`../context/architecture.md`](../context/architecture.md) so it's discoverable.

## Rules

- **Immutable.** Don't rewrite history. To change decision, write **new** ADR and set old one's status to `superseded by <new-file>`.
- **Self-contained.** Reader should understand decision without chasing links, though links help.

## Format

```markdown
# <short decision title>

- **Status:** proposed | accepted | superseded by <file> | deprecated
- **Date:** <YYYY-MM-DD>
- **Deciders:** <human(s) and/or agent>
- **Related:** <feature, REQ-…, or other ADRs>

## Context
What situation and forces prompted a decision? State constraints that matter.

## Decision
The choice, stated plainly. "We will …"

## Alternatives considered
- <Option A> — pros / cons; why not chosen.
- <Option B> — …

## Consequences
What becomes easier and harder; new constraints; follow-up work; how it will be
revisited if assumptions change.
```
