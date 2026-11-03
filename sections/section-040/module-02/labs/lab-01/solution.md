# Solution

Read the current configuration:

```sh
kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
```

The file has `backend.auth.dangerouslyDisableDefaultAuthPolicy: true`.

## Step 1: Edit the ConfigMap

```sh
kubectl -n backstage edit configmap backstage-app-config
```

Replace the `auth` block under `backend` and add the `permission` block at the top level:

```yaml
backend:
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

Keep the other `backend` settings as they are. Run `astrona submit`. The checks for the policy, the permission framework and the external access entry pass.

## Step 2: Deliver the token from the Secret

Add the variable to the container of the Deployment:

```sh
kubectl -n backstage set env deployment/backstage --from=secret/portal-secrets --keys=CI_TOKEN
```

This writes an `env` entry that reads the key from the Secret. If your `kubectl` version writes `envFrom` or copies the value instead of a `secretKeyRef`, edit the Deployment with `kubectl -n backstage edit deployment backstage` and set:

```yaml
env:
  - name: CI_TOKEN
    valueFrom:
      secretKeyRef:
        name: portal-secrets
        key: CI_TOKEN
```

Run `astrona submit`. The token check passes. The check for the running pod waits for a restart.

## Step 3: Restart and verify

Changing the Deployment starts a rollout by itself. If you only edited the ConfigMap, restart it:

```sh
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Run `astrona submit`. All checks pass once the new pod is ready.

## Why this works

With the default auth policy active, the backend requires credentials on every request. The `externalAccess` entry defines one non-user caller, identified by its subject and token. The `accessRestrictions` entry limits it to the catalog plugin. The `${CI_TOKEN}` placeholder is replaced with the value of the environment variable when the process starts, so the token lives only in the Secret.
