# Question

Solve this question on: `terminal`

This is the Section 020 capstone: one deployment that needs layered configuration files, a single override and a secret reference, with no step-by-step guidance.

Backstage runs in the namespace `backstage`. The Deployment `backstage` loads `app-config.yaml` from the image and `/etc/backstage/app-config.lab.yaml` from the ConfigMap `backstage-app-config`. That ConfigMap contains the GitHub token `ghp_starfleet_example_0000` as plain text. The team revoked it and created the new token `ghp_starfleet_example_0002`.

1. Store the new token in the Secret `portal-secrets` in `backstage` under the key `SCM_TOKEN`. In `backstage-app-config`, replace the plain token under `integrations.github` with a reference to the variable `SCM_TOKEN`, and keep every other setting. Give the container the variable from the Secret. No ConfigMap in the namespace may contain text that starts with `ghp_`, and the Deployment must not hold the token as a literal value.

2. Add a production overlay: a ConfigMap `backstage-app-config-production` with the key `app-config.production.yaml`. The file sets `organization.name` to `Starfleet Production` and `backend.cors.methods` to a list with exactly one item, `GET`. Mount the ConfigMap at `/etc/backstage-production` and load the file with a `--config` flag that comes last, so that its values have priority over the two existing files.

3. Override `app.title` without a file: set the environment variable `APP_CONFIG_app_title` to `Starfleet Portal Live` on the container.

4. Wait until the new pod is running. Do not change the image, do not delete the Deployment and do not remove the existing flags.

Check your work with `astrona submit`.
