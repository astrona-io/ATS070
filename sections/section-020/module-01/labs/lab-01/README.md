---
estimated_duration: 20m
---

# Lab: Layer A Production Configuration File And An Override

Graded lab for the configuration files module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Backstage starts with one mounted file. The learner adds a second ConfigMap with a production file, loads it as the last `--config` flag and sets an `APP_CONFIG_` override. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-01/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-01/labs/lab-01
astrona destroy ats-070-lab-020-01
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-production-configmap.sh` | The ConfigMap has `app.title` and a two-item `methods` list (text match on the YAML) |
| `validate-config-order.sh` | The production path is the last `--config` flag, after the lab file, and is mounted from the ConfigMap |
| `validate-env-override.sh` | The Deployment sets `APP_CONFIG_organization_name` to `Starfleet Command` |
| `validate-running-pod.sh` | The running pod has the file and the variable (via `kubectl exec`) |
| `validate-backstage-available.sh` | The image, the two original flags and an available replica; passes before any change |

## Open items (assumptions not verified by running)

- The image starts with `node packages/backend --config app-config.yaml --config <file>` and has `app-config.yaml` in its working directory `/app`.
- `kubectl exec` can run `test` and `printenv` in the image (it is a Debian-based Node image).
- Backstage accepts `backend.cors.methods` as a list of strings and starts with the layered files.
