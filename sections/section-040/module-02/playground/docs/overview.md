# Overview: Authentication, Authorization And Trust Boundaries (Playground)

This is a **playground**, not a lab. It starts a fresh single-node kind cluster with Backstage and a Secret, and then waits. There is no task, no `astrona submit` and no pass or fail. Change the authentication settings, restart the Deployment, send requests, `astrona destroy`, start over.

## What's in the box

- A kind cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- In the namespace `backstage`: the Deployment `backstage` (image `ghcr.io/backstage/backstage:1.55.2`), the Service `backstage` on port 7007, the ConfigMap `backstage-app-config` with the file `app-config.lab.yaml`, and the Secret `portal-secrets` with the key `CI_TOKEN`.
- The configuration does not set any authentication option, so the default auth policy of the backend is active. The permission framework is not enabled. The Secret is not yet used by the Deployment.
- Backstage is also forwarded to `http://127.0.0.1:7007` on your machine.

## Helpers

Paste these once in each new terminal. `show_config` prints the configuration file. `restart_backstage` restarts the Deployment and waits for the new pod. `backend_status` prints the HTTP status that the backend returns for a request without credentials, sent from inside the pod. `backend_status_with_token` does the same with a bearer token that you pass as the second argument.

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
backend_status_with_token() {
  kubectl -n backstage exec deploy/backstage -- node -e "fetch('$1', { headers: { Authorization: 'Bearer $2' } }).then(r => console.log(r.status)).catch(e => console.log('error', e.message))"
}
```

## Practice tasks

- Request `http://localhost:7007/api/catalog/entities` with `backend_status` and note the status. Then add `backend.auth.dangerouslyDisableDefaultAuthPolicy: true`, restart, and request again. Remove the option again afterwards.
- Add a static external access entry for the caller `starfleet-ci` with the token `${CI_TOKEN}`, add `CI_TOKEN` to the Deployment from the Secret `portal-secrets`, restart, and call the catalog route with `backend_status_with_token`. Read the token with `kubectl -n backstage get secret portal-secrets -o jsonpath='{.data.CI_TOKEN}' | base64 -d`.
- Add an `accessRestrictions` entry for the plugin `search` instead of `catalog`, restart, and call the catalog route with the token again. Compare the status with the previous call.
- Add `permission.enabled: true` to the configuration, restart, and check that the pod becomes ready.
- Run `kubectl -n backstage logs deploy/backstage` after each restart and read the start-up lines about authentication.
