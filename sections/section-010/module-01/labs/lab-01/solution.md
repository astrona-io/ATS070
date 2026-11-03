# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-01/labs/lab-01
```

Right after the start, `astrona submit` shows that the check `portal-answers` already passes. The other four fail.

## Step 1: Change the title and add the catalog rule

Read the current file in the ConfigMap:

```sh
kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}'
```

Save the full ConfigMap as `configmap-backstage-app-config.yaml`, with the new title and the rule:

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
      name: My Company
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

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-01/labs/lab-01 --keep
```

The checks `title-configured` and `catalog-rules` pass. The check `running-pod-uses-config` still fails, because the Deployment was not restarted.

## Step 2: Record the owner

The annotation goes on the Deployment, not on the pod:

```sh
kubectl -n backstage annotate deployment backstage portal.starfleet.example/owner=platform-team --overwrite
```

Annotating the Deployment does not restart the pod, because only a change to the pod template starts a rollout.

## Step 3: Restart and wait

Restart the Deployment. Kubernetes starts a new pod, which reads the changed file, and removes the old pod after the new one is ready:

```sh
kubectl -n backstage rollout restart deployment/backstage
kubectl -n backstage rollout status deployment/backstage --timeout=300s
```

Check what the new pod mounts:

```sh
kubectl -n backstage exec deployment/backstage -- cat /etc/backstage/app-config.lab.yaml
```

Grade the lab again with the same `astrona submit` command. All five checks pass.

If the new pod does not become ready, read its log with `kubectl -n backstage logs deployment/backstage`. A configuration mistake, such as wrong indentation in the file, stops the backend at start.
