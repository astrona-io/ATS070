---
draft: true
exam_objectives:
  - Deploy Backstage to production
---
# Summary

- A Deployment runs the Backstage container, a Service gives it a stable address on port 7007, and an Ingress routes the public host name to that Service.
- `app.baseUrl`, `backend.baseUrl` and the CORS origin must all match the address that users open.
- Credentials live in Secrets and reach the container through `envFrom`. Base64 is not encryption. A changed Secret or ConfigMap needs a restart of the Deployment.
- The backend exposes `/.backstage/health/v1/liveness` and `/.backstage/health/v1/readiness`. Readiness controls traffic. Liveness controls restarts.
- A rolling update replaces pods in steps set by `maxSurge` and `maxUnavailable`. The readiness probe decides when a new pod counts as available.
- Several replicas need a shared database. In-memory SQLite gives every pod its own data.
- `kubectl rollout undo` restores the previous pod template, not the data.
- A finished rollout shows availability. Feature health needs its own check after each release.

<!-- astrona:playground:destroy -->
