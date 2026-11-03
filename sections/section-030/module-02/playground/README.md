# Running On Kubernetes: Secrets, Probes And Releases - Playground

- **ID:** PLAYGROUND
- **Slug:** ats-070-playground-030-02
- **Author:** Paris Nakita Kejser
- **Type:** Astrona playground - clean environment, no task, no grading
- **Status:** built untested (never booted by the author)

A kind cluster with Backstage as a plain Deployment: a token written in the Deployment, no probes and one replica. PostgreSQL runs next to it. Nothing to submit.

## Run it

```sh
astrona run -c .
astrona destroy ats-070-playground-030-02
```

`astrona destroy` takes the environment name (`metadata.name`), not the config path.

## Layout

| Path | Purpose |
| --- | --- |
| `config.yaml` | Environment definition (kind, preloaded images, port forward, starting manifests) |
| `manifests/start.yaml` | The starting objects |
| `docs/overview.md` | What the environment contains and ideas to try |

## Open items

- The start command of the Backstage image (`node packages/backend --config app-config.yaml --config /etc/backstage/app-config.lab.yaml`) is assumed from the official Dockerfile and was not run.
