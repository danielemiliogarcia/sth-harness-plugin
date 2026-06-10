# Parallel Work & File Ownership

How to run **multiple AI agents in parallel** (separate branches or git worktrees, one feature each) without merge conflicts.

## The rule

> **Feature is unit of parallelism, and it owns all mutable state inside its own folder.** No file outside feature folder is written during normal feature work.

---

## How each potential hotspot is handled

| Mutable thing | Where it lives | Why conflict-free |
|---------------|--------------------|--------------------------|
| "What is active now" | `specs/<feature>/state.md` | One per feature; branch writes only its own. Global "now" is *derived* (which feature branch is on), not stored. |
| Task list + states | task table inside `specs/<feature>/state.md` | Per feature; no shared board. |
| Task/requirement IDs | scoped per feature (`T-1`, `REQ-1`) | No global counter — two branches can't collide on ID. Cite across features as `<feature>/T-1`. |
| Decisions (ADRs) | `decisions/YYYY-MM-DD-slug.md`, **no index file** | Date + slug rarely collides; directory listing *is* index — no shared index to conflict on. |
| Feature spec | `specs/<feature>/spec.md` | Separate file per feature. Split from `state.md` so churning task state never rewrites stable spec. |

---

## Keep shared static files out of feature branches

Shared static files: `README.md`, `roles.md`, `tool-linking.md`, everything in `context/`, `specs/global-spec-info.md`, `specs/global-state-info.md`, `specs/_template/`. Two feature branches editing one → conflict. During feature work:

- **New port, domain term, or convention introduced by feature?** Record in *your* `specs/<feature>/spec.md` (has "Feature-local conventions" block), **not** in `context/architecture.md` / `context/project.md`.
- **Want it project-wide?** Promote into shared `context/*` **deliberately, on main branch**, as its own small change — after feature merges. One writer, no race.

Treat shared static files as read-only while feature is in flight.

---

## Worktree workflow (suggested)

```text
main
 ├─ worktree A → branch feat/user-login    → writes specs/user-login/
 ├─ worktree B → branch feat/order-export  → writes specs/order-export/
 └─ worktree C → branch feat/rate-limit    → writes specs/rate-limit/
```

1. **Start feature.** From main, create branch + worktree named for feature. Copy `specs/_template/` → `specs/<feature>/`. Commit as feature's first step.
2. **Work.** Agent in each worktree reads/writes only its own feature folder (plus *reading* shared `context/*` as needed). Updates `specs/<feature>/state.md` as it goes.
3. **Resume.** Fresh session in worktree finds feature from branch name (see [`START-HERE.md`](START-HERE.md)) and reads that feature's `state.md`. No global pointer to consult or fight over.
4. **Finish & merge.** When feature is `done`, merge to main. Because only feature folder (and app code it produced) changed under `ai-harness/`, merge is clean. Leave feature folder in place with `state.md` marked `done` — it's the feature's record.

## Application code conflicts

Harness only guarantees *harness* files merge cleanly. App code can still conflict if two features edit same source files — ordinary merge work. Keep composition root small.

---

## Seeing all work

No global dashboard. To see all work:

- `ls specs/` — every feature is a folder.
- Read each `specs/*/state.md` header (phase + overall state).
