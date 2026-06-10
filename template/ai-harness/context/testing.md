# Testing & Validation Strategy

How project proves behavior. Tester writes acceptance tests from this; Implementer drives code with it; Reviewer checks against it.

**Core stance: TDD preferred when practical, not mandatory.** Validation *always* defined — either automated tests written first, or documented, scheduled plan to add later. Nothing ships "untested forever."

---

## Test pyramid (mapped to hexagonal layers)

```text
        /\        e2e / acceptance  — few, slow, high confidence
       /  \                          through driving adapters, real-ish edges
      /----\      integration       — adapters against real tech (DB, queue, API)
     /      \                         verify ports' implementations
    /--------\    unit               — many, fast
   /__________\                        domain rules + use cases with fakes
```

- **Unit (most tests).** Domain entities/value objects/services in isolation, use cases with **in-memory fakes** of ports. Fast, deterministic, no IO. Where hexagonal pays off: pure domain needs no mocks.
- **Integration (some).** Driven adapters against real technology (real DB, test broker/container). Confirms port's adapter works.
- **End-to-end / acceptance (few).** Through driving adapter (HTTP/CLI) across whole slice. Confirms requirement holds in assembled system.

Default to **lowest level** that can prove requirement.

---

## How acceptance tests connect to requirements

- Each acceptance test cites requirements it covers (`AT-3 covers REQ-2`).
- Write tests as **Given/When/Then** — readable, translates to code at any level.
- Mark tests intended to be written **first (red)** to drive implementation.
- Coverage goal: **every requirement maps to at least one test or explicit deferred-validation entry.** No requirement left unvalidated.

---

## TDD loop (when practical)

```text
red → green → refactor
```

1. Write failing test for next small behavior (from spec's Acceptance & Validation section).
2. Write minimal code to pass it.
3. Refactor with tests green.
4. Repeat.

Prefer thin **vertical slice** first (one path end to end) before broadening.

---

## When tests are deferred (allowed, but tracked)

Some work resists test-first: spikes/exploration, scaffolding, large refactors, infrastructure/environment setup, integrations not yet understood, UI needing human judgment. In those cases — **defer deliberately, never silently:**

1. Record **Deferred validation (`DV-n`)** block in spec's Acceptance & Validation section: **reason**, **interim/manual validation** to run now, **future automated path**.
2. Run interim/manual validation **before** moving task to `review`.
3. Create **follow-up `todo` task** in feature's task table (`specs/<feature>/state.md`) to add automated test when feasible.

Deferral is scheduling decision, not excuse to skip validation. Task is either tested, or carries explicit, scheduled plan to become tested.

---

## What makes good test here

- Tests **behavior and requirements**, not implementation details.
- Domain tests use **no mocks** (pure inputs/outputs).
- Use-case tests use **fakes of ports**, not heavyweight mocks.
- Deterministic: inject `Clock`, `IdGenerator`, randomness via ports.
- One reason to fail per test where practical; names state behavior asserted.

---

## Project-specific testing notes

> `<!-- CUSTOMIZE -->` Fill in once stack is chosen.

- Test runner / framework: _…_
- How to run all tests: _…_
- How to run single test: _…_
- Integration test setup (containers, fixtures, seed data): _…_
- Coverage expectations, if any: _…_
- Naming / location convention for tests: _…_
