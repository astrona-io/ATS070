# Solution

Solve this lab on `terminal`. Each step ends with `astrona submit`. The `--keep` flag keeps the lab running so you can continue after a failed check. This lab was built without running it, so the text describes what you should see instead of printing output.

Start the lab if it is not running:

```sh
astrona run --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-02/labs/lab-01
```

## Step 1: Read the anatomy from the running system

The command and the image are fields of the Deployment:

```sh
kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].command}{"\n"}'
kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}{"\n"}'
```

The command is `node packages/backend`. The release is the tag after the colon of the image. The plugin packages are in the pod:

```sh
kubectl -n backstage exec deployment/backstage -- sh -c 'ls /app/node_modules/@backstage | grep "^plugin-.*-backend$"'
```

Choose three names from the list. Create the record with your three names, one per line. The values below show the form; replace the plugin lines with names that the command printed:

```sh
kubectl -n backstage create configmap anatomy-record --from-literal=entry-command='node packages/backend' --from-literal=release=1.55.2 --from-literal=backend-plugins='plugin-NAME-ONE-backend
plugin-NAME-TWO-backend
plugin-NAME-THREE-backend'
```

Grade it:

```sh
astrona submit --git ssh://git@github.com/astrona-io/ATS070.git -c sections/section-010/module-02/labs/lab-01 --keep
```

The checks `entry-command`, `backend-plugins` and `release` pass.

## Step 2: Add the second configuration layer

Save this as `configmap-backstage-app-config-extra.yaml`:

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: backstage-app-config-extra
  namespace: backstage
data:
  app-config.extra.yaml: |
    app:
      title: Starfleet Operations Portal
```

Apply it:

```sh
kubectl apply -f configmap-backstage-app-config-extra.yaml
```

Now edit the Deployment. Add a volume, a mount and two arguments:

```sh
kubectl -n backstage edit deployment backstage
```

In the editor make these changes. Under `spec.template.spec.containers[0].args`, add the two lines `--config` and `/etc/backstage-extra/app-config.extra.yaml` after the existing ones. Under `volumeMounts`, add an entry with `name: app-config-extra`, `mountPath: /etc/backstage-extra` and `readOnly: true`. Under `volumes`, add an entry with `name: app-config-extra` and `configMap` with `name: backstage-app-config-extra`. Save and close the editor. Kubernetes starts a new pod because the pod template changed.

Wait for it:

```sh
kubectl -n backstage rollout status deployment/backstage --timeout=300s
kubectl -n backstage exec deployment/backstage -- cat /etc/backstage-extra/app-config.extra.yaml
```

Grade the lab again with the same `astrona submit` command. All five checks pass.

If the pod does not become ready, read `kubectl -n backstage logs deployment/backstage`. A wrong path in `--config` stops the backend at start.
