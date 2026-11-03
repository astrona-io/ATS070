# Solution

Work in steps and run `astrona submit` after each one. Checks about the running pod pass after the rollout in the last step.

## Step 1: create the Secret

Save this as `secret-portal-secrets.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: portal-secrets
  namespace: backstage
type: Opaque
stringData:
  SCM_TOKEN: ghp_starfleet_example_0002
```

Apply it:

```sh
kubectl apply -f secret-portal-secrets.yaml
```

## Step 2: replace the token with a reference and add the overlay

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
          token: ${SCM_TOKEN}
```

Save this as `configmap-backstage-app-config-production.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config-production
  namespace: backstage
data:
  app-config.production.yaml: |
    organization:
      name: Starfleet Production
    backend:
      cors:
        methods: [GET]
```

Apply both:

```sh
kubectl apply -f backstage-app-config.yaml
kubectl apply -f configmap-backstage-app-config-production.yaml
```

The overlay holds only the keys that differ. The `methods` array replaces any array set by an earlier file, and the `organization.name` string replaces the earlier value.

## Step 3: change the Deployment

Save this as `deployment-backstage.yaml`. It is the full Deployment with two more `args`, two `env` entries, and a second volume with its mount:

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: backstage
  namespace: backstage
  labels:
    app: backstage
spec:
  replicas: 1
  selector:
    matchLabels:
      app: backstage
  template:
    metadata:
      labels:
        app: backstage
    spec:
      containers:
        - name: backstage
          image: ghcr.io/backstage/backstage:1.55.2
          command: ["node", "packages/backend"]
          args:
            - "--config"
            - "app-config.yaml"
            - "--config"
            - "/etc/backstage/app-config.lab.yaml"
            - "--config"
            - "/etc/backstage-production/app-config.production.yaml"
          env:
            - name: APP_CONFIG_app_title
              value: "Starfleet Portal Live"
            - name: SCM_TOKEN
              valueFrom:
                secretKeyRef:
                  name: portal-secrets
                  key: SCM_TOKEN
          ports:
            - name: http
              containerPort: 7007
          readinessProbe:
            httpGet:
              path: /.backstage/health/v1/readiness
              port: http
            initialDelaySeconds: 20
            periodSeconds: 5
          volumeMounts:
            - name: app-config
              mountPath: /etc/backstage
              readOnly: true
            - name: app-config-production
              mountPath: /etc/backstage-production
              readOnly: true
      volumes:
        - name: app-config
          configMap:
            name: backstage-app-config
        - name: app-config-production
          configMap:
            name: backstage-app-config-production
```

Apply it and wait for the new pod:

```sh
kubectl apply -f deployment-backstage.yaml
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Then check the result:

```sh
kubectl -n backstage exec deploy/backstage -- printenv SCM_TOKEN APP_CONFIG_app_title
kubectl -n backstage get configmaps -o yaml
```

The variables show the new values, and no ConfigMap contains `ghp_` text. If the pod does not become ready, read `kubectl -n backstage logs deploy/backstage` and `kubectl -n backstage describe pod -l app=backstage`. Then run `astrona submit`.
