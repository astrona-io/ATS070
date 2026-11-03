# Question

Solve this question on: `terminal`

The Deployment `backstage` in the namespace `backstage` has a GitHub token written as a plain environment value (`GITHUB_TOKEN`), no probes and one replica. Make it ready for production release:

1. Create the Secret `backstage-secrets` in `backstage` with the key `GITHUB_TOKEN` and the same value that the Deployment carries now. Remove the plain `GITHUB_TOKEN` entry from the Deployment and load the Secret with `envFrom`.
2. Add a readiness probe on the Backstage readiness endpoint and a liveness probe on the Backstage liveness endpoint, both `httpGet` on the container port named `http`.
3. Run two replicas. Use the `RollingUpdate` strategy with `maxUnavailable` set to `0` so that a ready pod is never removed before its replacement is ready.
4. Wait until both new pods are ready.

Submit when the rollout has finished.
