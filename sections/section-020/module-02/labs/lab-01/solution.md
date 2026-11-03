# Solution

Work in steps and run `astrona submit` after each one. The Secret check passes after step 1. The others pass after the rollout in step 3.

## Step 1: create the Secret

Save this as `secret-backstage-secrets.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backstage-secrets
  namespace: backstage
type: Opaque
stringData:
  GITHUB_TOKEN: ghp_starfleet_example_0001
```

Apply it:

```sh
kubectl apply -f secret-backstage-secrets.yaml
```

The Secret stores the value. `stringData` lets you write plain text, and Kubernetes stores it encoded.

## Step 2: replace the token in the ConfigMap with a reference

Read the current file first:

```sh
kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
```

Save this as `backstage-app-config.yaml`. It is the whole ConfigMap with the reference in place of the token:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config
  namespace: backstage
data:
  app-config.lab.yaml: |
    app:
      title: Starfleet Portal
      baseUrl: http://localhost:7007
    organization:
      name: Starfleet
    backend:
      baseUrl: http://localhost:7007
      listen:
        port: 7007
      cors:
        origin: http://localhost:7007
      database:
        client: better-sqlite3
        connection: ':memory:'
    integrations:
      github:
        - host: github.com
          token: ${GITHUB_TOKEN}
```

Apply it:

```sh
kubectl apply -f backstage-app-config.yaml
```

Backstage replaces `${GITHUB_TOKEN}` with the value of the environment variable when it loads the file.

## Step 3: give the container the variable and restart

The next command adds every key of the Secret as an environment variable. Changing the pod template starts a new pod, and the new pod reads both the new file and the variable at startup:

```sh
kubectl -n backstage set env deployment/backstage --from=secret/backstage-secrets
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Then check the result and run `astrona submit`:

```sh
kubectl -n backstage exec deploy/backstage -- printenv GITHUB_TOKEN
kubectl -n backstage get configmaps -o yaml
```

The variable shows the new token and the ConfigMap output contains no `ghp_` text. If the pod does not become ready, read `kubectl -n backstage logs deploy/backstage` and `kubectl -n backstage describe pod -l app=backstage`.
