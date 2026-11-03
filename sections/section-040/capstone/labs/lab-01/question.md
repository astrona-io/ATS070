# Question

Solve this question on: `terminal`

This is the Section 040 capstone: one portal, no step-by-step guidance. The Starfleet portal runs in the namespace `backstage` as the Deployment `backstage`, with the configuration in the ConfigMap `backstage-app-config` (file `app-config.lab.yaml`) and the Secret `portal-secrets` (key `CI_TOKEN`). The portal moves to production behind a reverse proxy at `https://portal.starfleet.example`. The proxy serves the frontend and sends `/api` requests to the backend on the same address.

1. Public address. `app.baseUrl`, `backend.baseUrl` and `backend.cors.origin` all use `https://portal.starfleet.example`.
2. Port. The backend keeps listening on 7007, and the container port and the Service stay on 7007.
3. Authentication. The backend must require credentials on every route. Remove the option that switches the default auth policy off.
4. Authorization. Enable the permission framework.
5. CI caller. The CI pipeline calls the catalog as the external caller `starfleet-ci`. Today the token is written as a literal value in the ConfigMap. Keep the `starfleet-ci` subject and the restriction to the plugin `catalog`, but read the token from the environment variable `CI_TOKEN`, which the Deployment fills from the Secret `portal-secrets` with a `secretKeyRef`. The literal token must not stay in the ConfigMap.
6. Restart the Deployment and wait for the new pod. A request without credentials to `/api/catalog/entities` must not return HTTP 200.

Submit with `astrona submit` to see which checks pass.
