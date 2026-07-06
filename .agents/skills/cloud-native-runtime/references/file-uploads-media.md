# File Uploads and Media Reference

Use this for object storage, direct uploads, media resizing, scanning, thumbnails, CDN delivery, and signed URLs.

## Upload Architecture

Prefer direct-to-object-storage uploads for large files:

1. Authenticated client requests an upload intent.
2. API validates ownership, type, size, and business rules.
3. API creates a short-lived signed URL or multipart upload contract.
4. Client uploads directly to object storage.
5. Storage event or callback triggers validation, scanning, metadata persistence, and optional media processing.
6. Client or user polls status when processing is async.

## Security Requirements

- Enforce file size, MIME, extension, and content validation server-side.
- Treat all uploaded content as untrusted.
- Use private buckets by default.
- Keep signed URLs short-lived and scoped to object key and method.
- Avoid user-controlled object keys without normalization and prefix scoping.
- Add malware scanning or quarantine when business risk requires it.
- Strip or constrain metadata that may leak sensitive data.

## Media Processing

- Make transformations idempotent.
- Store original and derived asset metadata separately.
- Bound CPU, memory, dimensions, duration, and output formats.
- Use queue-based processing for large or slow media work.
- Emit progress/status and failure reason when users wait on processing.

## CDN Delivery

- Use immutable object keys or versioned URLs for cacheability.
- Define cache-control, content-type, content-disposition, and CORS intentionally.
- Invalidate only when versioned keys are not practical.
