# Networking and Caching Reference

Use this for DNS, CDN, CloudFront-equivalent routing, origins, private networking, CORS, cache behavior, and edge rules.

## CDN and Cache Checklist

- Identify origin, path patterns, methods, headers, query strings, cookies, and cache keys.
- Define static, dynamic, authenticated, and user-specific paths separately.
- Set explicit TTLs and cache-control headers.
- Avoid caching personalized or authorization-dependent responses unless the cache key includes the required variation.
- Prefer immutable asset names over broad invalidations.
- Validate CORS with actual allowed origins, methods, and headers.
- Add logs and metrics for cache hit ratio, origin errors, and latency.

## Networking Checklist

- Verify public versus private exposure.
- Scope security groups, firewall rules, routes, and service endpoints narrowly.
- Keep TLS termination and certificate ownership explicit.
- Avoid cross-region or cross-zone assumptions without latency and cost review.
- Verify egress costs and NAT dependencies.

## Anti-Patterns

- Forwarding all headers/cookies to a CDN by default.
- Disabling cache to avoid understanding invalidation.
- Wildcard CORS in authenticated flows.
- Public buckets or origins that are intended to be CDN-only.
