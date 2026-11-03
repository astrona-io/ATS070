# Solution

Work in a terminal. After each step, run `astrona submit` to see which checks pass.

## Step 1: Read the Deployment

```sh
kubectl -n backstage get deployment backstage -o yaml
```

The container has an `env` entry `GITHUB_TOKEN` with a `value`, no `readinessProbe` and no `livenessProbe`, and `replicas: 1`. Copy the token value.

## Step 2: Move the token into a Secret

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

Submit. The check `token-in-secret` passes.

## Step 3: Change the Deployment once

One patch removes the plain token, loads the Secret, adds both probes and sets the replicas and the strategy. One change starts one rollout. Save this as `backstage-release-patch.yaml`:

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
```

Then wait:

```sh
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

The readiness probe keeps a new pod out of the Service until the endpoint answers. `maxUnavailable: 0` keeps the old pod until a new pod is ready.

## Step 4: Submit

Submit again. All five checks pass when both pods are ready. If a pod restarts again and again, read `kubectl -n backstage describe pod` for failed liveness probes: the liveness probe starts after 60 seconds so that Backstage has time to start.
