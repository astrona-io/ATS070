# Solution

Work in a terminal. After each step, run `astrona submit` to see which checks pass.

## Step 1: Look at the starting state

Start with the current database settings and the pods:

```sh
kubectl -n backstage get configmap backstage-app-config -o yaml
kubectl -n backstage get pods
kubectl -n backstage get secret postgres-secrets -o jsonpath='{.data}'
```

The ConfigMap shows `client: better-sqlite3` and `connection: ':memory:'`. The Secret lists the two keys. Do not decode the password.

## Step 2: Switch the configuration to PostgreSQL

Save this as `backstage-app-config.yaml`:

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
        client: pg
        connection:
          host: ${POSTGRES_HOST}
          port: ${POSTGRES_PORT}
          user: ${POSTGRES_USER}
          password: ${POSTGRES_PASSWORD}
```

Apply it:

```sh
kubectl apply -f backstage-app-config.yaml
```

Submit. The check `db-config-uses-pg` passes and `password-not-plain` already passes. Backstage reads this file only at startup, so the running pod still uses SQLite.

## Step 3: Pass the credentials and the address

Save this as `backstage-database-patch.yaml`:

```yaml
spec:
  template:
    spec:
      containers:
        - name: backstage
          envFrom:
            - secretRef:
                name: postgres-secrets
          env:
            - name: POSTGRES_HOST
              value: postgres
            - name: POSTGRES_PORT
              value: "5432"
```

Apply it:

```sh
kubectl -n backstage patch deployment backstage --patch-file backstage-database-patch.yaml
```

Then wait for the new pod:

```sh
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

The patch changes the pod template, so Kubernetes starts a new pod that reads the changed ConfigMap and the new variables.

## Step 4: Submit

Submit again. All five checks pass when the new pod is ready and PostgreSQL is untouched. If `backstage-db-available` fails, the pod is not ready yet or has not been replaced: check `kubectl -n backstage get pods` and `kubectl -n backstage logs deployment/backstage`.
