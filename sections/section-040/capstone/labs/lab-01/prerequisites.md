# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory, and internet access to pull the Backstage image.
- `kubectl` and `jq`.
- You know how base URLs, CORS, the default auth policy, external access tokens and Kubernetes Secrets work.

The lab starts a single-node kind cluster (Kubernetes 1.35) with Backstage in the namespace `backstage`. Backstage needs a minute or more to become ready.
