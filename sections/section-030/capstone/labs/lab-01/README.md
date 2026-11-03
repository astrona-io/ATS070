---
estimated_duration: 40m
---

# Lab: Deploy Backstage To Production Capstone

Graded lab for the production deployment section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/capstone/labs/lab-01
astrona destroy ats-070-capstone-030
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-db-config-uses-pg.sh` | The ConfigMap selects PostgreSQL with POSTGRES_ substitutions |
| `validate-password-not-plain.sh` | The database password is in neither the ConfigMap nor the Deployment |
| `validate-db-env-from-secret.sh` | Backstage reads postgres-secrets and sets POSTGRES_HOST and POSTGRES_PORT |
| `validate-token-in-secret.sh` | The Secret backstage-secrets holds GITHUB_TOKEN |
| `validate-token-not-plain.sh` | The Deployment reads the token from the Secret only |
| `validate-probes-configured.sh` | Readiness and liveness probes use the Backstage health endpoints |
| `validate-replicas-rolling.sh` | Two replicas and RollingUpdate with maxUnavailable 0 |
| `validate-base-url-aligned.sh` | app.baseUrl, backend.baseUrl and backend.cors.origin use the public address |
| `validate-ingress-routes-to-backstage.sh` | The Ingress backstage sends the public host to backstage:7007 |
| `validate-backstage-available.sh` | Two ready Backstage pods run the changed template |

## Open items (assumptions not yet run)

- The image `ghcr.io/backstage/backstage:1.55.2` is started with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`. The working directory `/app` and the file `app-config.yaml` inside the image are assumed from the official Dockerfile, not confirmed by running the image.
- Backstage is assumed to create its per-plugin databases in PostgreSQL itself. The checks read cluster state and do not query PostgreSQL.
- The readiness path `/.backstage/health/v1/readiness` and the liveness path `/.backstage/health/v1/liveness` are documented. The start time of the image (`initialDelaySeconds`) is an estimate.
- No ingress controller is installed. The Ingress is graded as a resource only; the checks send no request through it.
- The strategic merge patch directive `$patch: delete` on the env entry is assumed to remove `GITHUB_TOKEN` (standard Kubernetes behaviour, not run here).
