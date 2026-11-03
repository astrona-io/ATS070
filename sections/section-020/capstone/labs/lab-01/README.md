---
estimated_duration: 30m
---

# Lab: Configure Backstage Capstone

Capstone for the Configure Backstage section. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

One deployment needs a secret moved out of a ConfigMap, a production overlay loaded as the last `--config` flag and an `APP_CONFIG_` override. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/capstone/labs/lab-01
astrona destroy ats-070-capstone-020
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-secret-rotated.sh` | `portal-secrets` has `SCM_TOKEN` with the new value |
| `validate-configmap-clean.sh` | No ConfigMap contains `ghp_`; the file refers to `${SCM_TOKEN}` and keeps its settings |
| `validate-deployment-uses-secret.sh` | `secretKeyRef` or `envFrom` to `portal-secrets`; no literal value |
| `validate-production-overlay.sh` | Overlay content, mount and last `--config` flag |
| `validate-title-override.sh` | `APP_CONFIG_app_title` is `Starfleet Portal Live` |
| `validate-running-pod-files.sh` | The running pod has the overlay file and the override |
| `validate-running-pod-token.sh` | The running pod has the new `SCM_TOKEN` |
| `validate-backstage-available.sh` | Image, original flags, an available replica; passes before any change |

## Open items (assumptions not verified by running)

- The image starts with `node packages/backend --config app-config.yaml --config <file>...` and has `app-config.yaml` in `/app`.
- Backstage resolves `${SCM_TOKEN}` in a mounted file and starts with an example GitHub token.
- `kubectl exec` can run `test` and `printenv` in the image.
