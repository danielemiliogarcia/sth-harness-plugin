# START HERE

AI coding agent (or human) starting session. Read first. Tiny on purpose.

Repo uses **model- and provider-agnostic AI development harness** built from folders and Markdown only. Works with any assistant that reads files (Claude Code, Codex, Copilot, Pi, OpenCode, Gemini CLI, Aider, future agents). Nothing depends on specific model or vendor.

Harness is **parallel-safe by design**: each feature owns all mutable state inside its own folder — multiple agents on different features in separate branches/worktrees, no merge conflicts. See [`parallel-work.md`](parallel-work.md).

---

## Boot sequence (every fresh session)

1. **Find feature.** One feature per branch/worktree. Identify:
   - branch/worktree name (usually matches folder in `specs/`);
   - human's instruction;
   - `ls specs/` matched to task. If unclear, ask.
2. **Read feature's live anchor:** `specs/<feature>/state.md`. Names phase, next action, read budget, task table. Heart of resumability.
3. **Open only what read budget lists** — typically section of `specs/<feature>/spec.md` for current phase. Don't read other features or whole repo.
4. **Adopt role** for current phase (see [`roles.md`](roles.md)).
5. **Do work.**
6. **Before stopping, update `specs/<feature>/state.md`** (phase, last step, next action, task states). If updating one file before stopping, make it this one.

Whole protocol. Everything else pulled on demand.

---

## If no feature exists yet (fresh project)

No work in flight. Adopt **Planner** role ([`roles.md`](roles.md)), then:

1. Customize [`context/project.md`](context/project.md): what project is, where app source lives, how to build/run/test.
2. Start first feature: **copy whole `specs/_template/` folder** to `specs/<feature-name>/` (short, kebab-case). On feature branch.
3. As **Spec Author**, fill `specs/<feature>/spec.md` requirements and set `specs/<feature>/state.md` (phase = `requirements`, next action). Bare freeform — see [`specs/global-spec-info.md`](specs/global-spec-info.md) and [`specs/global-state-info.md`](specs/global-state-info.md) for structure and legal values.

---

## To understand system (optional, read once)

- [`README.md`](README.md) — what harness is and how it works.
- [`parallel-work.md`](parallel-work.md) — file ownership + worktree workflow + merge rules. **Read before running multiple agents in parallel.**
- [`roles.md`](roles.md) — hats worn for each phase.
- [`specs/global-spec-info.md`](specs/global-spec-info.md) / [`specs/global-state-info.md`](specs/global-state-info.md) — how to fill feature's `spec.md` / `state.md`.
- [`context/architecture.md`](context/architecture.md) — hexagonal rulebook.
- [`context/testing.md`](context/testing.md) — TDD when practical, deferred validation when not.
- [`tool-linking.md`](tool-linking.md) — how human connects AI tool to harness via thin adapter file.
