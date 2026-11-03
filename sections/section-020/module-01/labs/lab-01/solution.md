# Solution

Work in steps and run `astrona submit` after each one. The check for the production ConfigMap passes after step 1, and the others pass after the rollout in step 3.

## Step 1: create the production file

Save this as `configmap-backstage-app-config-production.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config-production
  namespace: backstage
data:
  app-config.production.yaml: |
    app:
      title: Starfleet Portal Production
    backend:
      cors:
        methods: [GET, POST]
```

Apply it:

```sh
kubectl apply -f configmap-backstage-app-config-production.yaml
```

The file holds only the keys that differ. Objects merge, so the other keys of `app` and `backend` keep the values from the earlier files. The `methods` array replaces any array that an earlier file sets.

## Step 2: mount the file and add the flag and the variable

First read the Deployment, so that you can keep what is there:

```sh
kubectl -n backstage get deployment backstage -o yaml
```

Save this as `deployment-backstage.yaml`. It is the full Deployment with three changes: two more `args`, one `env` entry and one more volume with its mount.

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
            - name: APP_CONFIG_organization_name
              value: "Starfleet Command"
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

Apply it:

```sh
kubectl apply -f deployment-backstage.yaml
```

The new flag is last, so its values win over the two earlier files. The variable wins over every file.

## Step 3: wait for the new pod and check

```sh
kubectl -n backstage rollout status deployment/backstage --timeout=300s
kubectl -n backstage exec deploy/backstage -- cat /etc/backstage-production/app-config.production.yaml
kubectl -n backstage exec deploy/backstage -- printenv APP_CONFIG_organization_name
```

Changing the pod template starts a new pod, so the process reads the new files and the variable at startup. If the pod does not become ready, read `kubectl -n backstage logs deploy/backstage` and `kubectl -n backstage describe pod -l app=backstage`. Then run `astrona submit`.
