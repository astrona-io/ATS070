# Frontend, Backend And Service Discovery — Playground

- **ID:** PLAYGROUND
- **Slug:** ats-070-playground-040-01
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground — clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with Backstage from `ghcr.io/backstage/backstage:1.55.2` in the namespace `backstage`, configured by a ConfigMap. Backstage is forwarded to `127.0.0.1:7007`. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-070-playground-040-01
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, port forward, starting manifest) |
| `manifests/backstage.yaml` | Namespace, ConfigMap, Deployment and Service |
| `docs/overview.md` | What the environment contains and ideas to try |

## Open items

- The container command and arguments (`node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`) assume the working directory `/app` and a repository `app-config.yaml` inside the image. Not verified by running the image.
