# Framework Features, Integrations And Application Ownership - Playground

- **Slug:** ats-070-playground-010-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground, clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with one Backstage Deployment in the namespace `backstage`. It runs the public image `ghcr.io/backstage/backstage:1.55.2`. The ConfigMap `backstage-app-config` is mounted at `/etc/backstage` and passed to the backend with a second `--config` flag. The database is SQLite in memory. Service port 7007 is forwarded to `127.0.0.1:7007`.

## Run it

```sh
astrona run -c .
astrona destroy ats-070-playground-010-01
```

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (kind, preloaded images, port forward, starting manifest) |
| `manifests/backstage.yaml` | Namespace, ConfigMap, Deployment and Service |
| `docs/overview.md` | What the environment contains and ideas to try |

## Open items

- The start arguments assume that the image has the working directory `/app` with `app-config.yaml`. Verify on first boot.
- The image is the public demonstration image of the Backstage project, not an organization image.
