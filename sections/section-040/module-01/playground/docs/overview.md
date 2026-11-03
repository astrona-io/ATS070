# Overview: Frontend, Backend And Service Discovery (Playground)

This is a **playground**, not a lab. It starts a fresh single-node kind cluster with one Backstage Deployment and then waits. There is no task, no `astrona submit` and no pass or fail. Read the configuration, change it, restart the Deployment, look again, `astrona destroy`, start over.

## What's in the box

- A kind cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- In the namespace `backstage`: the Deployment `backstage` (image `ghcr.io/backstage/backstage:1.55.2`, one replica), the Service `backstage` on port 7007 and the ConfigMap `backstage-app-config`.
- The ConfigMap holds one file, `app-config.lab.yaml`. It is mounted at `/etc/backstage` and loaded after the `app-config.yaml` of the image, so its values win. It sets `app.baseUrl` and `backend.baseUrl` to `http://localhost:7007`, `backend.listen.port` to 7007, `backend.cors.origin` to `http://localhost:7007` and an in-memory SQLite database.
- Backstage is also forwarded to `http://127.0.0.1:7007` on your machine. The forward needs the pod to be ready, which can take a minute or more.

## Helpers

Paste these once in each new terminal. `show_config` prints the configuration file. `restart_backstage` restarts the Deployment and waits until the new pod is ready. `backend_status` prints the HTTP status that the backend returns inside the pod for the URL you pass.

```sh
show_config() {
  kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
}
restart_backstage() {
  kubectl -n backstage rollout restart deployment/backstage
  kubectl -n backstage rollout status deployment/backstage --timeout=300s
}
backend_status() {
  kubectl -n backstage exec deploy/backstage -- node -e "fetch('$1').then(r => console.log(r.status)).catch(e => console.log('error', e.message))"
}
```

Use them like this: `show_config`, `restart_backstage`, `backend_status http://localhost:7007/.backstage/health/v1/readiness`.

## Practice tasks

- Read the configuration with `show_config` and name the file the backend loads before it. Check the pod arguments with `kubectl -n backstage get deploy backstage -o jsonpath='{.spec.template.spec.containers[0].args}'`.
- Request `http://localhost:7007/` and `http://localhost:7007/api/catalog/entities` with `backend_status` and compare. Write down which process answers each request.
- Change `backend.cors.origin` to a different origin, restart, and request the same URLs again. Decide which request a browser would reject and which a command line client would not.
- Change `app.baseUrl` to `https://portal.starfleet.example`, restart, and explain why the readiness probe still passes while the portal address you would give users is not reachable in this cluster.
- Run `kubectl -n backstage logs deploy/backstage` and find the line that tells you on which port the backend listens.
