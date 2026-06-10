# Roles

**Role** = hat worn for one phase. Same AI (or human) wears different hats at different times. Each role says *what to read*, *what to produce*, *when to hand off*. Don't read every role — just the one matching current phase (named in feature's `state.md`).

| Phase | Role | Section |
|-------|------|---------|
| (any — bootstrap) | Session Loader | [↓](#session-loader) |
| idea · tasks · done | Planner | [↓](#planner) |
| requirements · design | Spec Author | [↓](#spec-author) |
| validation | Tester | [↓](#tester) |
| implementation | Implementer | [↓](#implementer) |
| review | Reviewer | [↓](#reviewer) |

Handoff: role finishes → writes artifact + updates `state.md`. Next role reads it, opens only what it needs. All paths relative to `specs/<feature>/`. Write only your own feature folder.

---

## Session Loader

**Purpose:** orient fresh session with minimum context, then switch to role matching current phase.

**Read (in order, stop early):**

1. [`START-HERE.md`](START-HERE.md) — boot sequence (if not already read).
2. Identify feature (branch/worktree name, human's instruction, or `ls specs/`).
3. `specs/<feature>/state.md` — phase, next action, read budget, task table.
4. Only if next action needs it: relevant section of `specs/<feature>/spec.md`.

**Stop.** Now know phase and next action. Don't open other features or whole `context/`. Trust `state.md` read budget.

**Produce:** nothing yet — clear mental model ("phase X, feature Y, next action Z, files needed are …"), then adopt matching role.

**Edge cases:**

- **Task is `blocked`.** Read blocker. Clear if possible; otherwise surface it, pick next unblocked task or ask human.
- **`state.md` points to missing file.** Small bug: locate it, repair pointer, note fix.
- **No feature for branch / no features at all.** Switch to **Planner**; shape or create feature (copy `specs/_template/`).

---

## Planner

**Purpose:** keep work flowing. Decides next step, turns ideas into features, breaks features into tasks, closes done work. No production code.

Serves **idea**, **tasks**, and **done** phases.

**Read:** feature's `state.md`, [`specs/global-state-info.md`](specs/global-state-info.md) for task-line format + legal states, spec's design when breaking work down.

**Produce, by phase:**

- **idea → feature:** new `specs/<feature>/` folder (copy of `_template/`), one-paragraph intent in `spec.md`, `state.md` initialized (phase = `requirements`). On dedicated feature branch.
- **feature → tasks:** populate Tasks table in feature's `state.md`, each task with ID (`T-1`, … scoped to feature), state `todo`, and requirements + acceptance tests it satisfies.
- **done:** mark tasks `done` in `state.md`, set feature's overall state to `done`, record cross-cutting `decisions/` ADR if needed.

**Break feature into tasks:** walk spec's Design outside-in (driving adapter → use case → domain → driven adapter/port); each slice ~1-2 tasks. Each task: stable per-feature ID, observable done-criteria, cited REQ/AT IDs. Order for independent testability — thin vertical slice first. If not testable first, mark it and record deferred-validation plan.

**Prioritize:** (1) unblock/cancel `blocked`; (2) close `review` (cheap); (3) smallest `todo` proving riskiest assumption. Record reasoning in `state.md`.

**Checklist:**

- [ ] Anything `blocked`? Clear or cancel first.
- [ ] Anything in `review`? Confirm and close.
- [ ] Each new task cites requirements + validation?
- [ ] `state.md` "Next action" is genuine next step?

---

## Spec Author

**Purpose:** define what/why (requirements) and how (hexagonal design). No production code.

Serves **requirements** and **design** phases.

**Read:** [`specs/global-spec-info.md`](specs/global-spec-info.md) for spec structure + ID rules, feature's `spec.md` (current draft), [`context/project.md`](context/project.md) for domain and goals, — for design phase — [`context/architecture.md`](context/architecture.md). Cite constraints already fixed in [`decisions/`](decisions/README.md).

**Produce — `spec.md` § Requirements:**

- Clear **problem statement** and **value/why**.
- **Functional requirements**, each with per-feature ID (`REQ-1`, …), written as testable observable behavior, not implementation.
- **Non-functional requirements** that matter.
- Explicit **in-scope/out-of-scope**, **assumptions**, **open questions** (list them — never silently assume).
- Hand off to **Tester** to turn requirements into acceptance tests *before* design hardens, when practical.

**Produce — `spec.md` § Design (hexagonal):**

- **Domain model** (entities, value objects, invariants) — pure, no IO.
- **Ports** feature needs (named for capability, not technology).
- **Adapters** that implement them and **use cases** that orchestrate.
- **Dependency direction** (everything points inward toward domain).
- New ports/terms/conventions go in spec's **Feature-local conventions** block, not in shared `context/*` (keeps parallel branches conflict-free).
- **Trade-offs considered**; link `decisions/` ADR for anything cross-cutting.
- Enough detail for Planner to cut tasks and Implementer to build — no speculative design for nonexistent requirements.

**Checklist:**

- [ ] Every requirement has ID and is testable.
- [ ] Scope (in/out), assumptions, open questions explicit.
- [ ] Design names domain, ports, adapters, use cases distinctly.
- [ ] Dependency direction points inward to domain.
- [ ] `state.md` updated: phase, last step, next action.

---

## Tester

**Purpose:** define how each requirement will be proven before implementation. Acceptance tests or explicit deferred-validation plan. No silent gaps.

Serves **validation** phase. See [`context/testing.md`](context/testing.md).

**Read:** spec's requirements, [`specs/global-spec-info.md`](specs/global-spec-info.md) for how acceptance/`DV` entries are written, [`context/testing.md`](context/testing.md).

**Produce — in `spec.md` § Acceptance & Validation:**

- One **acceptance test** per requirement (or several), written as **Given/When/Then**, each citing requirements it covers (`AT-3 covers REQ-2`) and level (unit/integration/e2e). Mark tests meant to be written **first (red)** to drive TDD.
- For anything not testable first, **deferred-validation block** (`DV-1`): **reason**, **interim/manual check** to run before `review`, **future automated path**, **follow-up task** (added to feature's task table).
- **Coverage map**: every requirement maps to at least one `AT-*` or `DV-*`. Requirement with no row is a gap.

**Checklist:**

- [ ] Every requirement maps to `AT-*` or `DV-*` (no gaps).
- [ ] Tests behavior-focused, use Given/When/Then.
- [ ] Each deferral records reason + interim check + future path + follow-up task.

---

## Implementer

**Purpose:** build feature. Smallest correct code satisfying current task, domain pure, state honest.

Serves **implementation** phase.

**Read:** **active task** in feature's `state.md` (task states + line format in [`specs/global-state-info.md`](specs/global-state-info.md)), relevant **slice** of spec's design (not whole thing), cited acceptance tests, [`context/architecture.md`](context/architecture.md). Read only slice the task touches.

**The loop (TDD preferred):**

1. Set task to `doing` in `state.md`.
2. Pick next acceptance/unit test task must satisfy; write it so it **fails** (red) if not yet written.
3. Implement **smallest** change that makes it pass (green).
4. Refactor with tests green; remove duplication; keep domain clean.
5. Repeat until done-criteria met, then move task to `review`.

If TDD impractical, follow deferred-validation plan: implement, run documented manual check, confirm follow-up test task exists. **Never silently skip validation.**

**Hexagonal discipline while coding:** domain code imports nothing external (no DB driver, HTTP client, framework, filesystem, clock, env). Need something outside? Call **port**; implement in **adapter** at edge. Use cases orchestrate only. Quick self-check: *could I unit-test this domain logic with no mocks of outside world?* If not, infrastructure leaked inward.

**Keep state honest:** update task state as you go; if new work discovered, add task to *this feature's* table (or note for future feature) rather than silently expanding current task; record cross-cutting technical choices as `decisions/` ADR.

**Checklist:**

- [ ] Task set to `doing` at start.
- [ ] Tests drove change (or deferral plan followed).
- [ ] Domain free of infrastructure imports; external access via port + adapter.
- [ ] Done-criteria met; tests green (or manual validation run).
- [ ] New discoveries captured as tasks, not smuggled into this task.
- [ ] Task moved to `review`; `state.md` updated.

---

## Reviewer

**Purpose:** verify task against requirements and validation before `done`. Coverage and architectural integrity — not personal taste.

Serves **review** phase.

**Read:** spec's Requirements + Acceptance & Validation sections for task, and changed code.

**Check:**

- **Requirements coverage** — does work satisfy every cited `REQ-*`?
- **Validation evidence** — do cited `AT-*` pass, or has `DV-*` interim check run and follow-up task created?
- **Hexagonal boundaries** — domain free of infrastructure; external access via ports/adapters; use cases hold no business rules. (See self-check in [`context/architecture.md`](context/architecture.md).)
- **State hygiene** — feature's `state.md` consistent and resumable.

**Outcome:** on pass, mark task `done` in `state.md` and hand to Planner to close (set feature's overall state when all tasks done). On fail, move back to `doing` with specific, actionable notes.

**Checklist:**

- [ ] Every cited requirement satisfied.
- [ ] Validation passed or deferral plan honored.
- [ ] Hexagonal boundaries intact.
- [ ] `state.md` consistent and resumable.
