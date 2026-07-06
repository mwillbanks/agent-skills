# Architecture Decision Tree

```text
Need runtime change?
  -> Is it user-facing synchronous work?
     -> Yes: API/server path unless latency or timeout budget forces async.
     -> No: event, worker, scheduler, or batch path.
  -> Is state long-lived or shared?
     -> Yes: choose explicit persistence and consistency model.
     -> No: keep runtime stateless.
  -> Is the behavior commodity cloud capability?
     -> Yes: compare managed service, cost, operability, portability.
     -> No: keep domain logic in app-owned code.
  -> Is production data or access affected?
     -> Yes: require security, observability, rollback, and readiness gates.
```
