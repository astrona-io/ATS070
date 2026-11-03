---
estimated_duration: 20m
---

# Lab: Move A Leaked Token Into A Secret And Rotate It

Graded lab for the visibility and secrets module. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

Backstage starts with a plain-text example token in its ConfigMap. The learner stores a rotated token in a Secret, refers to it with `${GITHUB_TOKEN}` and wires it to the Deployment. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-02/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-020/module-02/labs/lab-01
astrona destroy ats-070-lab-020-02
```

Authors run the local copy with `astrona run -c <lab>` and prove the reference solution with `astrona test -c <lab>`.

## Checks

| Script | What it proves |
| --- | --- |
| `validate-secret-rotated.sh` | `backstage-secrets` has `GITHUB_TOKEN` with the new value, not the leaked one |
| `validate-configmap-clean.sh` | No ConfigMap contains `ghp_`; the file refers to `${GITHUB_TOKEN}` and keeps its other settings |
| `validate-deployment-uses-secret.sh` | `secretKeyRef` or `envFrom` to the Secret; no literal value |
| `validate-running-pod-token.sh` | The running pod has the new value (via `kubectl exec printenv`) |
| `validate-backstage-available.sh` | Image, original flags and an available replica; passes before any change |

## Open items (assumptions not verified by running)

- Backstage resolves `${GITHUB_TOKEN}` in a mounted file and accepts the `integrations.github` entry with an example token value without checking it at startup.
- `kubectl exec` can run `printenv` in the image.
