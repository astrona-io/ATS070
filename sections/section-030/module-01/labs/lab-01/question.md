# Question

Solve this question on: `terminal`

The Starfleet Portal in the namespace `backstage` runs Backstage with the default in-memory SQLite database. Every restart loses the catalog. A PostgreSQL server is already running in the same namespace as the Service `postgres` on port `5432`. Its data lives on the PersistentVolumeClaim `postgres-data`, and its credentials are in the Secret `postgres-secrets` with the keys `POSTGRES_USER` and `POSTGRES_PASSWORD`.

Move Backstage to PostgreSQL:

1. In the ConfigMap `backstage-app-config`, key `app-config.lab.yaml`, set `backend.database` to the client `pg`. The connection values `host`, `port`, `user` and `password` must come from the substitutions `${POSTGRES_HOST}`, `${POSTGRES_PORT}`, `${POSTGRES_USER}` and `${POSTGRES_PASSWORD}`. Remove the SQLite settings. Keep the other settings.
2. In the Deployment `backstage`, give the container the credentials by referencing the Secret `postgres-secrets` with `envFrom`. Set `POSTGRES_HOST` to the Service name `postgres` and `POSTGRES_PORT` to `5432` as plain environment variables.
3. Never write the database password in the ConfigMap or the Deployment.
4. Wait until a new Backstage pod is ready. Do not change or delete PostgreSQL, its claim or its Secret.

Submit when the new pod is ready.
