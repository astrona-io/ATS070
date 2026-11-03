# Overview: Application Anatomy: Frontend, Backend And Plugins (Playground)

This is a **playground**, not a lab. It starts a kind cluster with one Backstage application and waits. There is no task, no `astrona submit` and no pass or fail. Look inside the image and map what you find to the roles of the packages.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` points at it as the cluster administrator.
- The namespace `backstage` with the Deployment `backstage` (image `ghcr.io/backstage/backstage:1.55.2`), the ConfigMap `backstage-app-config` mounted at `/etc/backstage` and the Service `backstage` on port 7007, forwarded to `http://127.0.0.1:7007`.
- The backend starts with `node packages/backend` and two `--config` files. The database is SQLite in memory.

## Practice tasks

- List `/app` and `/app/packages` in the pod and name the entry packages.
- List the names in `/app/node_modules/@backstage` that match `plugin-*-backend` and group them by feature.
- Find the names that match `plugin-*-backend-module-*` and say which plugin each module extends.
- Read the `version` field in the `package.json` of three framework packages and compare it with the image tag.
- Request `/api/catalog/entities` without a token and note the status code. Explain what it tells you about routing and authentication.
- Read the start of the backend log and write down the plugin IDs that you see.
