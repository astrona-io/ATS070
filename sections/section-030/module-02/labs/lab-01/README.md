---
estimated_duration: 25m
---

# Lab: Secrets, Probes And A Safe Rollout

Graded lab for the production deployment section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/module-02/labs/lab-01
astrona destroy ats-070-lab-030-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-token-in-secret.sh` | `backstage-secrets` has `GITHUB_TOKEN` with the value the Deployment used to hold |
| `validate-token-not-plain.sh` | The Deployment has no token text and references `backstage-secrets` through `envFrom` |
| `validate-probes-configured.sh` | `httpGet` readiness and liveness probes on the two health paths, port `http` or `7007` |
| `validate-replicas-rolling.sh` | `replicas: 2`, `RollingUpdate`, `maxUnavailable` `0` |
| `validate-backstage-available.sh` | Two non-terminating pods are Ready and have a liveness probe |

## Open items (assumptions not yet run)

- The image `ghcr.io/backstage/backstage:1.55.2` is started with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`. The working directory `/app` and the file `app-config.yaml` inside the image are assumed from the official Dockerfile, not confirmed by running the image.
- Backstage is assumed to create its per-plugin databases in PostgreSQL itself. The checks read cluster state and do not query PostgreSQL.
- The readiness path `/.backstage/health/v1/readiness` and the liveness path `/.backstage/health/v1/liveness` are documented. The start time of the image (`initialDelaySeconds`) is an estimate.
- Two Backstage replicas share no state when the database is SQLite in memory. The lab grades the Deployment and pod state only, not data.
- The strategic merge patch directive `$patch: delete` on the env entry is assumed to remove `GITHUB_TOKEN` (standard Kubernetes behaviour, not run here).
