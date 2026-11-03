# Question

Solve this question on: `terminal`

The Starfleet portal runs in the namespace `backstage` as the Deployment `backstage`. Its configuration is in the ConfigMap `backstage-app-config`, file `app-config.lab.yaml`. Someone switched off the default auth policy of the backend to make a test easier and never switched it on again. The Secret `portal-secrets` holds the key `CI_TOKEN` for the CI pipeline of the platform team.

1. Switch the default auth policy back on. Remove `backend.auth.dangerouslyDisableDefaultAuthPolicy` (or set it to `false`).
2. Enable the permission framework with `permission.enabled: true`.
3. Give the CI pipeline access as an external caller. Add one `backend.auth.externalAccess` entry with `type: static`, the subject `starfleet-ci`, the token `${CI_TOKEN}` (a placeholder for an environment variable) and an `accessRestrictions` entry for the plugin `catalog`.
4. Deliver the token from the Secret. Add an environment variable `CI_TOKEN` to the `backstage` container that reads the key `CI_TOKEN` of the Secret `portal-secrets` with a `secretKeyRef`. The ConfigMap must never contain the token value.
5. Restart the Deployment and wait until the new pod is ready. A request without credentials to `/api/catalog/entities` must not return HTTP 200.

Submit with `astrona submit` after each step to see which checks pass.
