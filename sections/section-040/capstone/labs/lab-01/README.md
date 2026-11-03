---
estimated_duration: 40m
---

# Lab: Client-Server Architecture Capstone

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

One portal that must be published behind a reverse proxy with authenticated backend routes and a CI caller whose token is not stored in the ConfigMap. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/capstone/labs/lab-01
astrona destroy ats-070-capstone-040
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-base-urls-and-cors.sh` | the three public address values match |
| `validate-default-auth-policy-enabled.sh` | the option dangerouslyDisableDefaultAuthPolicy is not true |
| `validate-permission-enabled.sh` | permission.enabled is true |
| `validate-ci-token-from-secret.sh` | placeholder, secretKeyRef, subject, restriction and no literal token |
| `validate-ports-unchanged.sh` | listen port, Service and container port are unchanged |
| `validate-restarted-and-ready.sh` | the running pod is newer than the last ConfigMap change and available |
| `validate-unauthenticated-rejected.sh` | an unauthenticated request to /api/catalog/entities does not return HTTP 200 |

## Open items (unverified assumptions)

- The image `ghcr.io/backstage/backstage:1.55.2` starts with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`, with the working directory `/app`, and the repository's `app-config.yaml` is present in the image. If the image uses another working directory or file names, fix `command` and `args` in `manifests/lab-start.yaml`.
- The readiness path `/.backstage/health/v1/readiness` is served by the image (documented for the root health service).
- The in-memory SQLite settings in the lab configuration are accepted by the image.
- With `permission.enabled: true` the image registers a permission policy module (the default allow-all policy), so the backend still starts.
- `node` in the image is version 18 or later, so `fetch` exists for the unauthenticated request check.
- The backend answers an unauthenticated request to `/api/catalog/entities` with a status other than 200 once the default auth policy is active. The documentation does not name the status; the check accepts any status except 200.
