# Review Standards

Review the PR as if it will merge unless you stop it.

## Human tone

- write like a direct human reviewer
- be blunt without being theatrical
- be brief when something is good
- spend the words on defects, not compliments
- do not say "AI review" or write an assistant-style summary

## What to inspect every time

- correctness
- security
- architecture and boundaries
- maintainability
- tests and validation coverage
- docs truthfulness when behavior or contracts changed

## Architecture and maintainability

Treat these as defects when they appear:

- hidden side effects
- poor separation of concerns
- logic in the wrong layer
- wrappers that only rename existing behavior
- duplicated transforms or validation
- boundary leaks between domains
- abstractions that add indirection without policy or reuse value
- one-off local helpers where existing primitives already solve the problem

## API domain and layer-boundary violations

Treat the API layer as an ingestion and orchestration boundary, not as the place to run heavy workflows.

Escalate these as architecture defects:

- endpoints that stream raw uploads through API memory or local disk instead of returning a presigned storage URL
- request handlers that perform long third-party sync pipelines inline instead of persisting pending state and handing work to an async worker or queue
- handlers that generate PDFs, manipulate large images, or run other heavy external workflows inside the request-response cycle
- endpoints acting as manual state machines with nested retries, timers, or polling loops instead of handing off multi-step distributed work to a real orchestrator

Healthy monolith rule:

- centralize routing, request validation, auth, and domain orchestration in the API layer
- move heavy execution, file transport, and long-running distributed workflows out of the request path

When an endpoint should really ingest and defer work, call that a `P1(ARCHITECTURE)` issue and push for event-driven or worker-based execution with a `202 Accepted` style contract when appropriate for the existing system.

## Security and reliability

Escalate quickly when you find:

- auth or authorization gaps
- injection risk
- secret handling mistakes
- race conditions
- missing retries or cancellation where required
- unbounded work
- silent failure paths
- unsafe casts or unchecked input

## Tests and validation

Treat missing or weak tests as real findings when the change affects:

- security rules
- money movement
- data integrity
- concurrency or retries
- migrations
- permission checks
- non-trivial UI state handling

If the PR claims validation that the diff does not support, call that out directly.

## Database anti-patterns and PostgreSQL performance

Do not stop at ORM readability. Review how the code will behave against the database engine.

Treat these as real defects:

- database queries inside `.map()`, `forEach`, `for`, `while`, or similar loops
- collection endpoints that fetch unbounded result sets without explicit pagination, limit, take, or cursor controls
- broad `SELECT *` or ORM relation loading that pulls full rows or large relations when only a narrow projection is needed
- iterative row inserts in a loop instead of bulk insert operations
- transactions that wrap network calls, third-party API calls, sleeps, or heavy CPU work
- hot filters, joins, or sort columns that appear unindexed
- query predicates that defeat indexing, such as `LOWER(column)` without a functional index

Best-practice corrections:

- batch lookups with joins or `WHERE id IN (...)`
- project only the required columns
- require pagination on collection reads
- use bulk writes for ingestion or fan-out writes
- keep transactions strictly around database work
- require indexes or functional indexes when the query shape obviously needs them

If the change would predictably exhaust the connection pool, amplify lock contention, or scan too much data, call it out directly even if the code is small.

## Async programming and runtime health

Protect the runtime, not just the code style.

Treat these as defects:

- CPU-heavy work on the main API thread or event loop
- `Promise.all()` or equivalent fan-out on a dynamically sized array without a concurrency limit
- async work kicked off without `await` after the response is sent
- unhandled or swallowed promise rejections
- empty catch blocks with no telemetry or error propagation

Best-practice corrections:

- offload CPU-heavy work to workers or background compute
- bound concurrency with an explicit limiter
- move fire-and-forget work onto a durable queue or task system
- require explicit error handling and telemetry

If the code can lose work on restart, starve the event loop, or burst through DB and HTTP connection pools, treat that as a meaningful reliability or architecture finding.

## Frontend standards

For frontend PRs, inspect all of the following:

- accessibility and semantic HTML
- keyboard interaction
- focus handling
- aria usage when necessary
- responsive behavior implied by the UI
- framework-compliant composition
- styling ownership and reuse

Treat these as defects:

- inline styles
- ad hoc style props used as a shortcut instead of a proper styled extension
- `sx` or equivalent one-off framework escape hatches when a reusable component or styled boundary is the right answer
- hardcoded design values where shared tokens or primitives should own them
- page-local duplication of shared UI patterns
- non-semantic click targets that should be buttons or links
- missing labels or inaccessible icon-only controls

Treat accessibility defects as merge blockers when they break basic operability, meaning:

- keyboard users cannot trigger or focus the control correctly
- screen reader users do not get a usable name for the control
- the wrong semantic element changes browser behavior or assistive-tech interpretation

When styling must change, prefer extending the existing framework or shared UI component first. Only accept a one-off component when the concern is truly isolated and not reusable.

## React-specific checks

If React is involved, inspect:

- hook dependency correctness
- stale closures
- derived state misuse
- prop API design
- state ownership
- render churn from avoidable rework
- effect cleanup

## Comment selection discipline

- Post only the comments that matter.
- Fold duplicate comments into one comment when the same fix applies.
- Use file-level comments for broad architecture patterns instead of spamming each occurrence.
- Do not waste review capital on trivia when blockers exist.

## Backend golden rules

Apply these consistently:

- the API layer is an ingestion engine; heavy synchronous execution in request handlers is usually a `P1(ARCHITECTURE)` problem
- protect the database from N+1 loops, missing pagination, long transactions, and bulk work expressed as row-by-row churn
- protect the runtime from dangling promises, unbounded concurrency, and event-loop blocking work