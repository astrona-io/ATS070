# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 3 GiB of free memory.
- `kubectl` and `jq`, and internet access to pull the Backstage and PostgreSQL images.
- You can edit a ConfigMap, a Secret, a Deployment and an Ingress with `kubectl`.

The lab starts a single-node kind cluster (Kubernetes 1.35) with Backstage in the namespace `backstage`. Backstage needs about a minute to become ready.
