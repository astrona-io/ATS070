---
estimated_duration: 35m
---

# Capstone: Repair, Configure And Document A Portal

Graded capstone for section 010. **Status: UNTESTED.** It was built without booting the lab; run `astrona test -c .` before relying on it.

The Backstage pod does not start because the ConfigMap key does not match the `--config` path. The learner repairs it, sets the title and the catalog rule, records the owner and writes a responsibilities record. The task is in `question.md`; the walkthrough is in `solution.md`.

## Run it

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/capstone/labs/lab-01
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/capstone/labs/lab-01
astrona destroy ats-070-capstone-010
```

## Checks

| Script | What it proves |
| --- | --- |
| `validate-portal-ready.sh` | A ready replica exists and a curl pod gets 200 from the readiness endpoint |
| `validate-workload-unchanged.sh` | Image `ghcr.io/backstage/backstage:1.55.2` and at least one replica |
| `validate-configuration.sh` | Title, one-line `allow:` list without `Template`, and the ready pod mounts the title |
| `validate-owner-annotation.sh` | Annotation `platform-team` on the Deployment |
| `validate-responsibilities-record.sh` | `owner`, `database` (names PostgreSQL), `identity` and `release` |

## Open items

- Assumption: a missing `--config` file makes the backend exit at start, so the pod never becomes ready. Verify on first boot.
- The starting state fails on purpose, so only `workload-unchanged` passes before any change.
