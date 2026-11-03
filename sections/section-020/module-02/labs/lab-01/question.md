# Question

Solve this question on: `terminal`

The Starfleet Portal runs Backstage in the namespace `backstage`. A reviewer found the GitHub token `ghp_starfleet_example_0000` as plain text in the ConfigMap `backstage-app-config`, under `integrations.github`. The team revokes that token and creates a new one, `ghp_starfleet_example_0001`. The new token must never be written into a ConfigMap.

1. Create the Secret `backstage-secrets` in `backstage` with the key `GITHUB_TOKEN` and the value `ghp_starfleet_example_0001`.

2. Change the ConfigMap `backstage-app-config` so that the GitHub integration token is the reference `${GITHUB_TOKEN}`. Keep every other setting of the file. No ConfigMap in the namespace may contain token text that starts with `ghp_`.

3. Give the `backstage` container the variable `GITHUB_TOKEN` from the Secret, with `valueFrom.secretKeyRef` or `envFrom`. Do not write the token as a literal value in the Deployment.

4. Wait until the new pod is running and has the variable. Do not change the image or delete the Deployment.

Check your work with `astrona submit`.
