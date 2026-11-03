---
draft: true
exam_objectives:
- Deploy Backstage to production
---
# Deploy Backstage To Production

This section covers what it takes to run Backstage as a production service: a container image with the built backend, a PostgreSQL database with persistent storage, and a Kubernetes deployment with Secrets, health probes and safe releases.

The section has two modules. The first covers the image, the database and the data that must survive. The second covers the Kubernetes objects, the credentials, the probes and the release process. Each module has a playground for hands-on commands and a graded lab. A capstone lab combines both modules, and a quiz closes the section.

## Learning Outcomes

- Describe the host build and the multi-stage build of the Backstage image, and what the image contains.
- Configure `backend.database` for PostgreSQL, and explain what in-memory SQLite loses on a restart.
- Explain how plugin databases are divided, and how migrations, backups and persistent volumes are handled.
- Align the Deployment, Service, Ingress and the `baseUrl` settings with the public address.
- Deliver credentials through Secrets and configure readiness and liveness probes against the backend health endpoints.
- Run a rolling release, roll it back, and tell availability apart from feature health.

## Learning Path

1. Module 1, Packaging, Persistence And Database: three parts, a playground and the lab "Move Backstage From SQLite To PostgreSQL".
2. Module 2, Running On Kubernetes: Secrets, Probes And Releases: three parts, a playground and the lab "Secrets, Probes And A Safe Rollout".
3. Capstone: "Deploy Backstage To Production Capstone".
4. Quiz: ten questions, pass score 70.

All labs and playgrounds run on a single-node `kind` cluster. The labs are untested and their README files say so.
