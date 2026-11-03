# Solution

Read the current configuration first:

```sh
kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
```

The file has `app.baseUrl: http://localhost:3000`, `backend.baseUrl: http://localhost:7007` and `backend.cors.origin: http://localhost:3000`. The proxy hides the internal port, so all three values describe the public address.

## Step 1: Edit the ConfigMap

Open the ConfigMap in an editor:

```sh
kubectl -n backstage edit configmap backstage-app-config
```

Change the three lines so that they read:

```yaml
app:
  baseUrl: https://portal.starfleet.example
backend:
  baseUrl: https://portal.starfleet.example
  cors:
    origin: https://portal.starfleet.example
```

Leave `backend.listen.port` at 7007. Run `astrona submit`. The checks for the three addresses and for the unchanged port pass. The check for the running pod still fails, because the process has not read the new file.

## Step 2: Restart Backstage

```sh
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

The Deployment creates a new pod. The new process reads the changed file. Run `astrona submit` again. All checks pass once the new pod is ready.

## Why this works

`app.baseUrl` is the address users type in the browser. `backend.baseUrl` is the address the browser uses to reach the backend. Behind one proxy both are the same public address. `backend.cors.origin` lists the origin of the page that may call the backend from a browser. `backend.listen.port` is the port of the process inside the pod, so the proxy and the Service still reach it on 7007.
