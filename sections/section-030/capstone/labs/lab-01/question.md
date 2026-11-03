# Question

Solve this question on: `terminal`

This is the Section 030 capstone: one production release, no step-by-step guidance.

Backstage in the namespace `backstage` runs from the image `ghcr.io/backstage/backstage:1.55.2` with an in-memory SQLite database, a GitHub token written as a plain value in the Deployment, no probes, one replica and the address `http://localhost:7007`. PostgreSQL runs next to it as the Service `postgres` with the Secret `postgres-secrets` and the claim `postgres-data`. Make the deployment ready for the public address `https://portal.starfleet.example.com`.

1. Database. In the ConfigMap `backstage-app-config`, key `app-config.lab.yaml`, use the client `pg` with `host`, `port`, `user` and `password` read from `${POSTGRES_HOST}`, `${POSTGRES_PORT}`, `${POSTGRES_USER}` and `${POSTGRES_PASSWORD}`. The container gets the credentials from `postgres-secrets` through `envFrom`, and `POSTGRES_HOST` is `postgres` and `POSTGRES_PORT` is `5432`. The password appears in no ConfigMap and no Deployment.
2. Secret. Move the token from the plain `GITHUB_TOKEN` value into the Secret `backstage-secrets` (same key, same value) and load it with `envFrom`. Keep both Secret references.
3. Probes. Add an `httpGet` readiness probe and an `httpGet` liveness probe on the documented Backstage health endpoints, on the port named `http`.
4. Release. Run two replicas with the `RollingUpdate` strategy and `maxUnavailable` `0`.
5. Address. `app.baseUrl`, `backend.baseUrl` and `backend.cors.origin` must all be `https://portal.starfleet.example.com`. Create an Ingress named `backstage` that sends the host `portal.starfleet.example.com` to the Service `backstage` on port `7007`.
6. Do not change PostgreSQL. Wait until both new pods are ready.

Submit when the rollout has finished.
