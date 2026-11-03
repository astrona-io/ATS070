---
estimated_duration: 25m
---

# Lab: Move Backstage From SQLite To PostgreSQL

Graded lab for the production deployment section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-030/module-01/labs/lab-01
astrona destroy ats-070-lab-030-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-db-config-uses-pg.sh` | `client: pg`, no `better-sqlite3`, and the four `${POSTGRES_*}` substitutions in `app-config.lab.yaml` |
| `validate-password-not-plain.sh` | The password value appears in neither the ConfigMap nor the Deployment |
| `validate-db-env-from-secret.sh` | `envFrom` names `postgres-secrets`; `POSTGRES_HOST` names the Service; `POSTGRES_PORT` is `5432` |
| `validate-postgres-persistent.sh` | The claim `postgres-data` is `Bound`, mounted by `postgres`, which is available |
| `validate-backstage-db-available.sh` | A running, ready Backstage pod has the `POSTGRES_HOST` variable |

## Open items (assumptions not yet run)

- The image `ghcr.io/backstage/backstage:1.55.2` is started with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`. The working directory `/app` and the file `app-config.yaml` inside the image are assumed from the official Dockerfile, not confirmed by running the image.
- Backstage is assumed to create its per-plugin databases in PostgreSQL itself. The checks read cluster state and do not query PostgreSQL.
- The readiness path `/.backstage/health/v1/readiness` and the liveness path `/.backstage/health/v1/liveness` are documented. The start time of the image (`initialDelaySeconds`) is an estimate.
- The PostgreSQL user `backstage` is the owner of the cluster (the image makes `POSTGRES_USER` a superuser), so Backstage is assumed to be allowed to create the plugin databases.
