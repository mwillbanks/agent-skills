# Async Decision Matrix

| Need | Recommended pattern | Watch for |
|---|---|---|
| Slow work after API request | Queue job plus status | User completion signal |
| External side effect with retry | Outbox plus worker | Duplicate delivery |
| Ordered per-entity processing | Partition by entity key | Poison message blocking |
| Fanout notifications | Event bus/topic | Subscriber isolation |
| Long multi-step process | Workflow engine | State visibility and compensation |
| Backfill | Batch job with checkpoint | Rate limits and partial failure |
