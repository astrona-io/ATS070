# Prerequisites

- The `astrona` command-line tool, installed and working (`astrona check` passes).
- A container engine that kind can use (Podman or Docker) with about 2 GiB of free memory and internet access to pull the Backstage image.
- `kubectl`.
- You know how to read a pod log, edit a ConfigMap and restart a Deployment.

The lab starts a single-node kind cluster (Kubernetes 1.35) with a Backstage Deployment in the namespace `backstage` that does not start.
