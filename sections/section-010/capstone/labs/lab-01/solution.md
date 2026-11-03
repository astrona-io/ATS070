# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/capstone/labs/lab-01
```

## Step 1: Find why the pod does not start

Look at the pod and its log:

```sh
kubectl -n backstage get pods
kubectl -n backstage logs deployment/backstage
kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].args}{"\n"}'
kubectl -n backstage get configmap backstage-app-config -o json | jq '.data | keys'
```

The arguments name the file `/etc/backstage/app-config.lab.yaml`. The ConfigMap provides a key with another name, so the file does not exist in the pod and the backend cannot load its configuration. The log of the backend reports the problem when it starts.

## Step 2: Repair the ConfigMap and set the values

Save this as `configmap-backstage-app-config.yaml`. It uses the key name that the arguments expect, the new title and the rule without `Template`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config
  namespace: backstage
data:
  app-config.lab.yaml: |
    app:
      title: Starfleet Developer Portal
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
    catalog:
      rules:
        - allow: [Component, System, API, Resource, Location]
```

Apply it:

```sh
kubectl apply -f configmap-backstage-app-config.yaml
```

The old key `app-config.yaml` is removed by the apply, because it was created with `kubectl apply` as well. If `kubectl get configmap backstage-app-config -o json | jq '.data | keys'` still shows it, delete it with `kubectl -n backstage patch configmap backstage-app-config --type=json -p '[{"op":"remove","path":"/data/app-config.yaml"}]'`.

## Step 3: Annotate and restart

```sh
kubectl -n backstage annotate deployment backstage portal.starfleet.example/owner=platform-team --overwrite
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

The restart replaces the pod that was waiting for the missing file. The new pod reads the corrected file.

## Step 4: Write the record

Save this as `configmap-portal-responsibilities.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: portal-responsibilities
  namespace: backstage
data:
  owner: platform-team
  database: PostgreSQL in production, because SQLite in memory loses all data at a restart
  identity: The platform team chooses and operates the sign-in provider and the permission policy
  release: "1.55.2"
```

Apply it:

```sh
kubectl apply -f configmap-portal-responsibilities.yaml
```

Grade the lab with `astrona submit`. All five checks pass.
