# Visibility, Typing And Secret Boundaries - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-070-playground-020-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with Backstage
(`ghcr.io/backstage/backstage:1.55.2`) in the namespace `backstage`. The container
loads `app-config.yaml` from the image and a second file mounted from the ConfigMap
`backstage-app-config`. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-070-playground-020-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, port forward, manifests) |
| `manifests/backstage.yaml` | Namespace, ConfigMap, Deployment and Service for Backstage |
| `docs/overview.md` | What the environment contains and ideas to try |

## Open items

- Untested: that the image starts with `--config app-config.yaml` plus the mounted file, and that `/app/app-config.yaml` exists in the image.
- The ConfigMap starts with `integrations.github[0].token` as a plain-text example token (`ghp_starfleet_example_0000`, not a real credential). The learner moves it to a Secret.
