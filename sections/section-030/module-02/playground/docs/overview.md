# Overview: Running On Kubernetes: Secrets, Probes And Releases (Playground)

This is a **playground**, not a lab. It starts a single-node `kind` cluster (Kubernetes 1.35) and waits. There is no task, no `astrona submit` and no pass or fail. Change the cluster, look at the result, `astrona destroy`, start over. `kubectl` is already pointed at the cluster. Backstage needs about a minute to become ready, and the first start pulls images.

## What's in the box

| Object | What it is |
| --- | --- |
| Deployment `backstage` | One replica, no probes, and the plain environment value `GITHUB_TOKEN` |
| Service `backstage` | Port 7007 to the container port named `http` |
| ConfigMap `backstage-app-config` | The configuration with SQLite in memory and `http://localhost:7007` |
| Deployment `postgres`, Service `postgres`, Secret `postgres-secrets` | PostgreSQL 16 for the database tasks |

Open `http://127.0.0.1:7007` in a browser once the pod is ready. Run a request from inside the cluster with `kubectl -n backstage run probe-check --rm -it --restart=Never --image=curlimages/curl:8.22.0 --command -- curl -s http://backstage:7007/.backstage/health/v1/readiness`.

## Practice tasks

- Run the curl command above for the readiness path and for `/.backstage/health/v1/liveness` and write down the responses.
- Create a Secret `backstage-secrets` with `kubectl create secret generic`, load it with `envFrom` and remove the plain token. Run `kubectl -n backstage rollout history deployment/backstage` and count the revisions.
- Add a readiness probe and a liveness probe, scale to two replicas with `maxUnavailable: 0`, and watch `kubectl -n backstage get pods -w` during the rollout.
- Add a probe with a wrong path and watch the new pod stay not ready while the old pod keeps serving. Roll back with `kubectl -n backstage rollout undo deployment/backstage`.
- Change `app.baseUrl` in the ConfigMap to another address, restart the pod and decide what the browser at `http://127.0.0.1:7007` does now.
