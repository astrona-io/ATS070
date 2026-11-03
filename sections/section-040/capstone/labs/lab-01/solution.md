# Solution

Read the configuration and the Deployment first:

```sh
kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
kubectl -n backstage get deployment backstage -o yaml
```

## Step 1: Edit the ConfigMap

```sh
kubectl -n backstage edit configmap backstage-app-config
```

Set the public address in three places, remove the option that disables the default auth policy, replace the literal token with a placeholder and add the permission block:

```yaml
app:
  baseUrl: https://portal.starfleet.example
backend:
  baseUrl: https://portal.starfleet.example
  cors:
    origin: https://portal.starfleet.example
  auth:
    externalAccess:
      - type: static
        options:
          token: ${CI_TOKEN}
          subject: starfleet-ci
        accessRestrictions:
          - plugin: catalog
permission:
  enabled: true
```

Leave `backend.listen.port` and the database settings as they are. Run `astrona submit`. The checks for the address, the policy and the permission framework pass.

## Step 2: Feed the token from the Secret

```sh
kubectl -n backstage set env deployment/backstage --from=secret/portal-secrets --keys=CI_TOKEN
```

If the result is not a `secretKeyRef` entry named `CI_TOKEN`, edit the Deployment and set `env` to a `CI_TOKEN` variable with `valueFrom.secretKeyRef` for `portal-secrets` and the key `CI_TOKEN`. Run `astrona submit`.

## Step 3: Restart and verify

```sh
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Run `astrona submit`. All checks pass once the new pod is ready.

## Why this works

The public address values describe where the browser reaches the portal, while the listen port describes the process inside the pod. Removing the disable option brings back the default auth policy, which rejects requests without credentials. The permission framework lets the policy decide what an authenticated caller may do. The placeholder keeps the token out of the ConfigMap, and the Secret delivers it to the process as an environment variable.
