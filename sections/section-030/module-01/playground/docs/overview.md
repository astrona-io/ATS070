# Overview: Packaging, Persistence And Database (Playground)

This is a **playground**, not a lab. It starts a single-node `kind` cluster (Kubernetes 1.35) and waits. There is no task, no `astrona submit` and no pass or fail. Change the cluster, look at the result, `astrona destroy`, start over. `kubectl` is already pointed at the cluster. Backstage needs about a minute to become ready, and the first start pulls images.

## What's in the box

| Object | What it is |
| --- | --- |
| Deployment `backstage` | The image `ghcr.io/backstage/backstage:1.55.2`, port 7007, configuration from the ConfigMap `backstage-app-config` |
| ConfigMap `backstage-app-config` | `app-config.lab.yaml` with `better-sqlite3` and `':memory:'` |
| Deployment `postgres`, Service `postgres` | PostgreSQL 16 on port 5432, data on the claim `postgres-data` |
| Secret `postgres-secrets` | The keys `POSTGRES_USER` and `POSTGRES_PASSWORD` for the server |

Open `http://127.0.0.1:7007` in a browser once the pod is ready.

## Practice tasks

- Run `kubectl -n backstage exec deploy/backstage -- ls /app` and read the files and folders that the image contains. Decide which of them are source code and which are a built bundle.
- Run `kubectl -n backstage exec deploy/backstage -- cat /app/app-config.yaml` and find the `backend.database` block that the image ships with.
- Switch Backstage to PostgreSQL: edit the ConfigMap, add `envFrom` and the host and port variables to the Deployment, and wait for the new pod. Read `kubectl -n backstage logs deploy/backstage` for the database lines.
- List the databases with `kubectl -n backstage exec deploy/postgres -- psql -U backstage -c '\l'` and decide how many databases Backstage created and what their names say.
- Delete the Backstage pod and the PostgreSQL pod one after the other and decide which one loses data, and why.
