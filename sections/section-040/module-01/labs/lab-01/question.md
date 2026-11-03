# Question

Solve this question on: `terminal`

The Starfleet portal runs in the namespace `backstage` as the Deployment `backstage`. Its configuration is in the ConfigMap `backstage-app-config`, in the file `app-config.lab.yaml`. The file still has local development addresses. The platform team will publish the portal behind a reverse proxy at `https://portal.starfleet.example`. The proxy serves the frontend and sends requests that start with `/api` to the backend, all on that one address.

1. Set `app.baseUrl` to `https://portal.starfleet.example`.
2. Set `backend.baseUrl` to `https://portal.starfleet.example`.
3. Set `backend.cors.origin` to the origin of the page, `https://portal.starfleet.example`.
4. Keep the port inside the cluster: `backend.listen.port`, the container port and the Service stay on 7007. Do not change the Service or the Deployment ports.
5. Backstage reads its files when it starts. Restart the Deployment and wait until the new pod is ready.

Submit with `astrona submit` after each step to see which checks pass.
