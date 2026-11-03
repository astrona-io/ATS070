# Question

Solve this question on: `terminal`

The platform team must document the anatomy of the Backstage image in the namespace `backstage`, and it must add a second configuration layer for the operations team. Do not change the image and do not delete the Deployment.

1. Create the ConfigMap `anatomy-record` in `backstage` with these keys, all taken from the running system:
   - `entry-command`: the command that the container runs, as one line.
   - `backend-plugins`: the names of at least three backend plugin packages that exist in the image folder `/app/node_modules/@backstage`, one name per line, in the form `plugin-<id>-backend` and without the scope.
   - `release`: the release tag of the image.

2. Create the ConfigMap `backstage-app-config-extra` in `backstage` with the key `app-config.extra.yaml`. The file sets `app.title` to `Starfleet Operations Portal` and nothing else.

3. Mount the new ConfigMap into the backstage container at `/etc/backstage-extra` with a new volume, and pass its file as the last configuration file of the backend. The existing `--config` arguments stay in place and stay before the new one.

4. Wait until the new pod is ready. The readiness endpoint of the Service `backstage` on port 7007 must answer.

`kubectl` already points at the cluster as the cluster administrator.
