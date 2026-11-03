# Solution

Work in a terminal. After each step, run `astrona submit` to see which checks pass.

## Step 1: Read the starting state

```sh
kubectl -n backstage get configmap backstage-app-config -o yaml
kubectl -n backstage get deployment backstage -o yaml
kubectl -n backstage get pods
```

## Step 2: One configuration file for the database and the address

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
      baseUrl: https://portal.starfleet.example.com
    organization:
      name: Starfleet
    backend:
      baseUrl: https://portal.starfleet.example.com
      listen:
        port: 7007
      cors:
        origin: https://portal.starfleet.example.com
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

Submit. The checks `db-config-uses-pg`, `password-not-plain` and `base-url-aligned` pass.

## Step 3: The token Secret and the Ingress

Save this as `backstage-secrets.yaml`:

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: backstage-secrets
  namespace: backstage
type: Opaque
stringData:
  GITHUB_TOKEN: ghp_labtokenvalue0000
```

Apply it:

```sh
kubectl apply -f backstage-secrets.yaml
```

Save this as `backstage-ingress.yaml`:

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: backstage
  namespace: backstage
spec:
  rules:
    - host: portal.starfleet.example.com
      http:
        paths:
          - path: /
            pathType: Prefix
            backend:
              service:
                name: backstage
                port:
                  number: 7007
```

Apply it:

```sh
kubectl apply -f backstage-ingress.yaml
```

## Step 4: One patch for the Deployment

Save this as `backstage-release-patch.yaml`:

```yaml
spec:
  replicas: 2
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 0
      maxSurge: 1
  template:
    spec:
      containers:
        - name: backstage
          envFrom:
            - secretRef:
                name: backstage-secrets
          env:
            - name: GITHUB_TOKEN
              $patch: delete
          readinessProbe:
            httpGet:
              path: /.backstage/health/v1/readiness
              port: http
            initialDelaySeconds: 20
            periodSeconds: 5
          livenessProbe:
            httpGet:
              path: /.backstage/health/v1/liveness
              port: http
            initialDelaySeconds: 60
            periodSeconds: 10
```

Apply it:

```sh
kubectl -n backstage patch deployment backstage --patch-file backstage-release-patch.yaml
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

The patch changes the pod template once, so the two new pods read the new configuration and the new variables together.

## Step 5: Submit

Submit again. All ten checks pass when both pods are ready. Use `kubectl -n backstage describe pod` to read failed probes, and `kubectl -n backstage logs deployment/backstage` for startup errors.
