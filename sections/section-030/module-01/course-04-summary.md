---
draft: true
exam_objectives:
  - Deploy Backstage to production
---
# Summary

A Backstage portal is an application that the organization builds from its own repository. The build produces a container image, either with a host build that runs Yarn on the build machine and copies the results into a small Dockerfile, or with a multi-stage build that does every step inside Docker. The image holds the code of every chosen plugin, the production dependencies and the `app-config*.yaml` files that were in the repository. It must not hold secrets, because every person who can pull the image can read them.

Without a database setting, each plugin uses an in-memory SQLite database. Its contents are lost when the process restarts, and replicas cannot share it. Production uses the `pg` client for PostgreSQL. The configuration names environment variables such as `${POSTGRES_PASSWORD}`, and a Kubernetes Secret supplies the values when the container starts. By default, each plugin gets its own logical database on the server, and `pluginDivisionMode: schema` gives each plugin a schema in one shared database instead.

The plugins run their own migrations while the backend starts. A new version can therefore change the schema before the old pods are gone, and rolling back the image does not roll back the database. Backstage takes no backups. The organization owns the database as a service: persistent storage that survives the loss of a pod, scheduled and tested backups, access control and upgrades.

Key facts:

- The image is the unit of release; environment values stay outside it.
- A ConfigMap change reaches a pod only when the pod starts again.
- A PersistentVolumeClaim keeps data when a pod is replaced, but it is not a backup.
- A restore that was never tested is not a plan.

<!-- astrona:playground:destroy -->
