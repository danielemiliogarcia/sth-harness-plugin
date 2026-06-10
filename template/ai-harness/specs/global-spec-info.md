# Global Spec Info — how to fill any feature's `spec.md`

**Shared, static reference. Read on demand (like `context/*`); don't copy into feature.** Defines structure, vocabulary, and rules for every `specs/<feature>/spec.md`. Each feature's `spec.md` is **bare freeform key:value** — only filled-in content. All the *how* lives here.

> **Parallel-safety:** shared static. Treat read-only during feature work; edit deliberately on main branch. See [`../parallel-work.md`](../parallel-work.md).

---

## What `spec.md` is

**Stable** part of feature: **requirements**, **acceptance & validation**, **hexagonal design**. Changes slowly. Volatile part (phase, next action, task states) lives in `state.md` — see [`global-state-info.md`](global-state-info.md).

Feature starts by copying `_template/` to `specs/<feature>/`, then filling `spec.md` in order: requirements → acceptance → design.

---

## ID rules (scoped per feature — no global counter)

- Requirements: `REQ-1`, `REQ-2`, … — stable within feature; **never renumber once cited**.
- Acceptance tests: `AT-1`, …  Deferred validations: `DV-1`, ….
- Cite across features with folder name: `order-submission/REQ-2`.
- IDs reset per feature — two parallel branches can never collide.

---

## The three sections

### 1. requirements (Spec Author, before any code)

- One-line **intent**, plus problem statement and value/why.
- **Functional requirements**, each with `REQ-*` id and priority (`must | should | could`), written as **observable behavior, not implementation**. If you can't imagine a test for it, refine it.
- Note **scope** (in/out), **assumptions**, **open questions** — never silently assume.

### 2. acceptance (Tester, ideally before implementation)

- One or more **acceptance tests** per requirement, written as **Given/When/Then**, each citing requirements it covers (`AT-3 covers REQ-2`) and level (`unit | integration | e2e`).
- Mark tests meant to be written **first (red)** to drive TDD.
- For anything not testable first, **deferred-validation** entry (`DV-n`) recording: reason, interim/manual check to run before `review`, future automated path, follow-up `todo` task added to `state.md`.
- **Coverage rule:** every `REQ-*` maps to at least one `AT-*` or `DV-*`. Requirement with no coverage is a gap.

See [`../context/testing.md`](../context/testing.md).

### 3. design (Spec Author, hexagonal)

Express in hexagonal terms — enough to cut tasks and build, no speculative design. See [`../context/architecture.md`](../context/architecture.md).

- **domain** — entities, value objects, invariants. Pure, no IO.
- **ports** — interfaces application declares, named for **capability** not technology (`OrderRepository`, not `PostgresClient`).
- **adapters** — driven (implement port: `SqlOrderRepository`) and driving (call app: `HttpOrderController`).
- **usecases** — orchestrate domain + ports; hold no business rules.
- **feature-local conventions** — new ports/terms this feature introduces go here, **not** in shared `context/*` (would conflict across parallel branches). Promote project-wide later, deliberately, on main.
- Dependency direction points **inward** to domain.

---

## Canonical freeform shape (worked example)

```
# spec: order-submission
intent: accept an order, enforce rules, persist it, return its id

requirements:
  REQ-1 (must): the system shall reject an order with zero items
  REQ-2 (must): a submitted order is persisted and its id returned

acceptance:
  AT-1 covers REQ-1 (unit, red):
    Given an empty cart / When submit / Then raise EmptyOrder
  AT-2 covers REQ-2 (integration):
    Given a valid order / When submit / Then it is saved and id returned

design:
  domain: Order (invariant: >= 1 item)
  ports: OrderRepository (save, byId), Clock (now)
  adapters: SqlOrderRepository (driven), HttpOrderController (driving)
  usecases: SubmitOrder (build Order -> enforce rules -> save via port -> return id)
  feature-local conventions: new port OrderRepository
```

Keep short. Anything needing more explanation than fits here signals requirement should be split, not that file should grow prose.
