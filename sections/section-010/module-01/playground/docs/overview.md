# Overview: Framework Features, Integrations And Application Ownership (Playground)

This is a **playground**, not a lab. It starts a kind cluster with one Backstage application and waits. There is no task, no `astrona submit` and no pass or fail. Read the configuration, change it, restart the pod and look at what changes.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- The namespace `backstage` with these objects:

  | Object | What it is |
  | --- | --- |
  | Deployment `backstage` | Runs `ghcr.io/backstage/backstage:1.55.2` with `node packages/backend` |
  | ConfigMap `backstage-app-config` | The file `app-config.lab.yaml`, mounted at `/etc/backstage` |
  | Service `backstage` | Port 7007, forwarded to `http://127.0.0.1:7007` on your machine |

- The database is SQLite in memory, so a restart removes all data. No catalog source is configured.

## Practice tasks

- Print the container arguments of the Deployment and explain which configuration file wins when both set the same key.
- Change `app.title` in the ConfigMap, restart the Deployment and check that the mounted file shows the new title in the new pod.
- Add a `catalog.rules` block that allows only `Component`, `System`, `API`, `Resource` and `Location`, restart, and read the backend log for errors.
- Add an `owner` annotation to the Deployment with `kubectl annotate` and check that the pod did not restart.
- Request `http://127.0.0.1:7007/.backstage/health/v1/readiness` while a restart is running and note the status codes you see.
- Write down which of the eight duties of the adopting organization you can see in this cluster, and which you cannot.
