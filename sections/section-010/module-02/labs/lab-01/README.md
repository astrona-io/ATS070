---
estimated_duration: 25m
---

# Lab: Map The Application And Add A Configuration Layer

Graded lab for the application anatomy module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The learner reads the anatomy of the Backstage image from the running pod, records it in a ConfigMap and adds a second configuration file as the last `--config` argument. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-02/labs/lab-01
astrona destroy ats-070-lab-010-02
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-entry-command.sh` | `entry-command` equals the container command of the Deployment |
| `validate-backend-plugins.sh` | At least three listed `plugin-<id>-backend` directories exist in the ready pod |
| `validate-release.sh` | `release` equals the image tag |
| `validate-extra-config-layer.sh` | The last two args are `--config /etc/backstage-extra/app-config.extra.yaml`, the first file is kept and the extra ConfigMap sets the title |
| `validate-running-pod-reads-extra.sh` | The ready pod has the extra file, the image is unchanged and a curl pod gets 200 from the readiness endpoint |

## Open items

- Assumption: the image has `/app/node_modules/@backstage` with at least three `plugin-*-backend` packages and the working directory `/app`. Verify on first boot.
- Assumption: a second `--config` file overrides `app.title` of the first one (last flag has the highest priority, per the configuration documentation).
