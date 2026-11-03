---
estimated_duration: 20m
---

# Lab: Configure And Own The Portal

Graded lab for the framework features and ownership module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The cluster starts with one Backstage Deployment that has a generic title, no catalog rules and no owner annotation. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-01/labs/lab-01
astrona destroy ats-070-lab-010-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-title-configured.sh` | `app.title` in the ConfigMap file is `Starfleet Developer Portal` |
| `validate-catalog-rules.sh` | The first `allow:` line has the five kinds and no `Template` |
| `validate-owner-annotation.sh` | The Deployment annotation is `platform-team` |
| `validate-running-pod-uses-config.sh` | `restartedAt` is set, the image is unchanged and the ready pod mounts the new title |
| `validate-portal-answers.sh` | A curl pod gets 200 from the readiness endpoint through the Service |

## Open items

- Assumption: the image starts with `node packages/backend --config app-config.yaml --config <file>` from `/app` and serves `/.backstage/health/v1/readiness` without authentication. Verify on first boot.
- The validation of `catalog.rules` reads the text of the file with `grep`, so it expects the one-line flow list form from the task.
- `portal-answers` passes before any change.
