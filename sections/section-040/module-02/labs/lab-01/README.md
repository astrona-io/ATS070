---
estimated_duration: 25m
---

# Lab: Secure The Backend Routes And Add A CI Caller

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Backstage starts with the default auth policy disabled, no permission framework and a Secret that holds a CI token. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/module-02/labs/lab-01
astrona destroy ats-070-lab-040-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-default-auth-policy-enabled.sh` | the option dangerouslyDisableDefaultAuthPolicy is not true |
| `validate-permission-enabled.sh` | permission.enabled is true |
| `validate-ci-access-configured.sh` | an externalAccess entry with the subject, a token placeholder and the restriction |
| `validate-token-from-secret.sh` | the Deployment env uses secretKeyRef and the token value is not in the ConfigMap |
| `validate-restarted-and-ready.sh` | the running pod is newer than the last ConfigMap change and available |
| `validate-unauthenticated-rejected.sh` | an unauthenticated request to /api/catalog/entities does not return HTTP 200 |

## Open items (unverified assumptions)

- The image `ghcr.io/backstage/backstage:1.55.2` starts with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`, with the working directory `/app`, and the repository's `app-config.yaml` is present in the image. If the image uses another working directory or file names, fix `command` and `args` in `manifests/lab-start.yaml`.
- The readiness path `/.backstage/health/v1/readiness` is served by the image (documented for the root health service).
- The in-memory SQLite settings in the lab configuration are accepted by the image.
- With `permission.enabled: true` the image registers a permission policy module (the default allow-all policy), so the backend still starts.
- `node` in the image is version 18 or later, so `fetch` exists for the unauthenticated request check.
- The backend answers an unauthenticated request to `/api/catalog/entities` with a status other than 200 once the default auth policy is active. The documentation does not name the status; the check accepts any status except 200.
