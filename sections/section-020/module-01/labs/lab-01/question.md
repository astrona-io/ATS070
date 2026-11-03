# Question

Solve this question on: `terminal`

The Starfleet Portal runs Backstage in the namespace `backstage`. The Deployment `backstage` loads two files with `--config`: `app-config.yaml` from the image and `/etc/backstage/app-config.lab.yaml` from the ConfigMap `backstage-app-config`. The operations team wants a production file layered on top, and one value overridden without a file.

1. Create the ConfigMap `backstage-app-config-production` in `backstage` with the key `app-config.production.yaml`. The file sets `app.title` to `Starfleet Portal Production` and `backend.cors.methods` to a list of exactly two methods, `GET` and `POST`.

2. Mount that ConfigMap in the `backstage` container at `/etc/backstage-production` and load the file with a `--config` flag. It must be the last `--config` flag, so that its values have priority over the two existing files. Keep the two existing flags.

3. Override `organization.name` with the environment variable `APP_CONFIG_organization_name` set to `Starfleet Command`.

4. Wait until the new pod is running. Do not change the image, and do not remove the existing flags or the existing ConfigMap.

Check your work with `astrona submit`.
