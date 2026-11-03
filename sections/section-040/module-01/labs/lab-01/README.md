---
estimated_duration: 20m
---

# Lab: Align Base URLs And CORS Behind A Reverse Proxy

Graded lab. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Backstage starts with development addresses in its configuration, but the portal is published behind a reverse proxy. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-040/module-01/labs/lab-01
astrona destroy ats-070-lab-040-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-app-base-url.sh` | app.baseUrl equals the public address |
| `validate-backend-base-url.sh` | backend.baseUrl equals the public address |
| `validate-cors-origin.sh` | backend.cors.origin equals the origin of app.baseUrl |
| `validate-listen-port-kept.sh` | listen port, Service targetPort and container port are unchanged |
| `validate-restarted-and-ready.sh` | the running pod is newer than the last ConfigMap change and available |

## Open items (unverified assumptions)

- The image `ghcr.io/backstage/backstage:1.55.2` starts with `node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`, with the working directory `/app`, and the repository's `app-config.yaml` is present in the image. If the image uses another working directory or file names, fix `command` and `args` in `manifests/lab-start.yaml`.
- The readiness path `/.backstage/health/v1/readiness` is served by the image (documented for the root health service).
- The in-memory SQLite settings in the lab configuration are accepted by the image.
