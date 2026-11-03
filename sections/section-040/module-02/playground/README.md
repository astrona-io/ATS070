# Authentication, Authorization And Trust Boundaries — Playground

- **ID:** PLAYGROUND
- **Slug:** ats-070-playground-040-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground — clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A single-node kind cluster (Kubernetes 1.35, `kindest/node:v1.35.8`) with Backstage from `ghcr.io/backstage/backstage:1.55.2`, a ConfigMap for the configuration and a Secret `portal-secrets` with `CI_TOKEN`. Backstage is forwarded to `127.0.0.1:7007`. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-070-playground-040-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (runtime, preloaded images, port forward, starting manifest) |
| `manifests/backstage.yaml` | Namespace, ConfigMap, Deployment, Service and the Secret |
| `docs/overview.md` | What the environment contains and ideas to try |

## Open items

- Container command and arguments assume the working directory `/app` and a repository `app-config.yaml` inside the image. Not verified by running the image.
- The status codes the backend returns for requests with and without credentials are not named in the documentation used; the playground does not state them.
