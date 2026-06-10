# Architecture — Hexagonal (Ports & Adapters)

Harness assumes **hexagonal** layout so domain stays pure, testable, independent of frameworks and infrastructure. Practical rulebook: Spec Author designs with it, Implementer builds with it, Reviewer checks against it.

---

## The layers

```text
┌─────────────────────────────────────────────────────────────┐
│ Adapters (outer edge)                                        │
│   driving: HTTP controllers · CLI handlers · schedulers · UI │
│   driven:  DB repositories · API clients · queues · clock    │
├─────────────────────────────────────────────────────────────┤
│ Application (use cases)                                       │
│   orchestrates the domain; declares Ports (interfaces)       │
├─────────────────────────────────────────────────────────────┤
│ Domain (pure core)                                           │
│   entities · value objects · domain services · rules         │
│   imports nothing external — no framework, IO, DB, HTTP, clock│
└─────────────────────────────────────────────────────────────┘
        dependencies point inward → toward the Domain
```

- **Domain** — entities, value objects, domain services, business rules. Pure. No imports of frameworks, IO, DB, HTTP, time, or env.
- **Port** — interface *owned by application*, describing something it needs from outside, in application's language. Examples: `OrderRepository`, `PaymentGateway`, `Clock`, `EventPublisher`.
- **Adapter** — concrete implementation at edge.
  - **Driven adapter** implements port using real tech (`SqlOrderRepository`).
  - **Driving adapter** calls application from outside (`HttpOrderController`, `CliHandler`).
- **Use case / application service** — orchestrates domain objects and ports to fulfil one request. Holds no business rules and no infrastructure detail.

---

## The dependency rule

```text
Driving adapter ──► Use case ──► Domain
                       │
                       └──► Port (interface)  ◄── implemented by ── Driven adapter
```

- Compile-time dependencies point **inward** (toward domain) — except adapters, which depend on ports they implement.
- Domain depends on **nothing** in outer rings.
- Application depends on **domain** and **its own port interfaces**, never on concrete adapters.
- Adapters wired to application at **composition root** (startup), via dependency injection.

---

## Do

- Put business rules and invariants **in domain** (e.g. "order needs at least one item" lives on `Order` entity, not in controller).
- Express external needs as **ports** in application's language.
- Implement ports in **adapters** at edge.
- Inject adapters into use cases from **composition root**.
- Pass **time, randomness, and IO** through ports (`Clock`, `IdGenerator`, `Repository`) so domain stays deterministic.
- Keep use cases thin: validate input shape, call domain, call ports, return.

## Don't

- ❌ Import database/ORM, HTTP client, framework, filesystem, or `now()` inside domain.
- ❌ Put business rules inside adapter or controller.
- ❌ Let use case depend on concrete adapter class.
- ❌ Leak transport/persistence shapes (DTOs, ORM rows, JSON) into domain; translate at adapter boundary.
- ❌ Reach for network or clock directly "just this once" — add port.

---

## Worked example (language-neutral pseudocode)

```text
# domain/order.*  — pure
Order:
  items: list
  rule: an Order with zero items is invalid → raise EmptyOrder

# application/ports.*  — interfaces the app declares
interface OrderRepository:   save(order); byId(id) -> Order
interface Clock:             now() -> Timestamp

# application/submit_order.*  — use case orchestrates
SubmitOrder(repo: OrderRepository, clock: Clock):
  run(command):
    order = Order.fromCommand(command, clock.now())   # domain enforces rules
    repo.save(order)                                   # via port
    return order.id

# adapters/sql_order_repository.*  — driven adapter (edge)
SqlOrderRepository implements OrderRepository:
  save(order): ...translate to rows, write to DB...

# adapters/http_order_controller.*  — driving adapter (edge)
HttpOrderController(submitOrder: SubmitOrder):
  POST /orders: id = submitOrder.run(parse(request)); return 201, id

# main.*  — composition root: wire concrete adapters into use cases
repo = SqlOrderRepository(db)
clock = SystemClock()
submitOrder = SubmitOrder(repo, clock)
http = HttpOrderController(submitOrder)
```

Domain (`Order`) unit-tests with no database and no HTTP. Use case tests with in-memory fakes of `OrderRepository` and `Clock`. Adapters get integration tests at edge.

---

## Naming conventions

- Name **ports** for capability, not technology (`OrderRepository`, not `PostgresClient`).
- Name **adapters** for technology + capability (`SqlOrderRepository`, `HttpOrderController`).
- Translate external shapes to domain types **at adapter boundary**, never deep inside.

---

## Self-check (use during review)

- Could I unit-test domain logic **without any mocks** of DB/HTTP/time? If not, infrastructure leaked inward.
- Does any domain file import from `adapters/` or a framework? Violation.
- Does use case reference concrete adapter instead of port? Introduce and inject port.
- Are transport/persistence shapes translated at boundary, not passed inward?

---

## Project-specific bindings

> `<!-- CUSTOMIZE -->` Record decisions shaping whole system (module layout for `src/`, DI/wiring, error-handling and transaction boundaries), and list real ports and adapters as they appear so agents reuse them instead of inventing new ones. Link significant choices to [`../decisions/`](../decisions/README.md) record.
>
> **Parallel-safety:** shared file. While feature is in flight, put its new ports in that feature's `spec.md`, not here — two feature branches both appending rows would conflict. Promote port to project-wide table **deliberately, on main branch**, after feature merges. See [`../parallel-work.md`](../parallel-work.md).

- Module / folder layout: _…_
- Dependency injection / wiring: _…_
- Error handling strategy: _…_
- Transaction / consistency boundaries: _…_

| Port (interface) | Purpose | Adapter(s) |
|------------------|---------|------------|
| _OrderRepository_ | _persist orders_ | _SqlOrderRepository_ |
| _Clock_ | _current time_ | _SystemClock / FixedClock (tests)_ |
