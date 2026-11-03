# Overview: Configuration Files, Merging And Overrides (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with Backstage running and then waits. There is no task, no `astrona submit` and no pass or fail. Change the configuration, restart the pod, look at the result, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- A Deployment `backstage` in the namespace `backstage` with one replica. Its container runs `node packages/backend` with two flags: `--config app-config.yaml` (the file in the image) and `--config /etc/backstage/app-config.lab.yaml` (the file from the ConfigMap).
- A ConfigMap `backstage-app-config` with the key `app-config.lab.yaml`. It sets the portal title, the organization name, the backend address and port, the CORS origin and an in-memory SQLite database.
- A Service `backstage` on port 7007. The port is also forwarded to `http://127.0.0.1:7007` on your machine.
- Backstage needs a minute or more to start. The Deployment has a readiness probe.

## Helpers

Paste this once in each new terminal. `restart_backstage` restarts the pod so that Backstage reads its configuration again and waits until the new pod is ready.

```sh
restart_backstage() {
  kubectl -n backstage rollout restart deployment/backstage
  kubectl -n backstage rollout status deployment/backstage --timeout=300s
}
```

## Practice tasks

- Add a `backend.cors.methods` list with three methods to the ConfigMap, run `restart_backstage`, and read the file in the pod with `kubectl -n backstage exec deploy/backstage -- cat /etc/backstage/app-config.lab.yaml`.
- Predict the effective value of `app.title` if you add `APP_CONFIG_app_title="Starfleet HQ"` to the Deployment. Then add it with `kubectl -n backstage set env` and check the variable in the pod with `printenv`.
- Create a second ConfigMap with an overlay file, mount it in the Deployment and add a third `--config` flag after the existing ones. Decide which values win and why.
- Reverse the order of the `--config` flags and write down which source now has priority.
- Break the path of the second flag on purpose, read the pod log and the events, and fix it.
