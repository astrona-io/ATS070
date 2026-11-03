---
draft: true
exam_objectives:
  - Configure Backstage
---
# Summary

Backstage describes the shape of its configuration with schemas. A package declares its schema in the `configSchema` field of `package.json`, as a JSON file or as a TypeScript `config.d.ts` file that exports a `Config` type. At startup Backstage combines the schemas of all packages that qualify into one schema and checks the loaded configuration against it. Code then reads values with typed readers. A required reader such as `getString` throws when the value is missing or has the wrong type. An optional reader such as `getOptionalString` returns `undefined` when the value is missing, and still throws on a wrong type.

Visibility decides who can see a value. The values are `frontend`, `backend` and `secret`. The default is `backend`, which keeps a value on the server. A value marked `frontend` is available to the browser application as well. A value marked `secret` is backend-only and may be left out of logs. The annotation applies to one field, and `@deepVisibility` applies to a field and everything below it. Marking a value as `frontend` is a decision to publish it to every visitor who loads the portal.

A secret must not be stored in a file that is kept in a repository or in a ConfigMap, because both are readable by many people. On Kubernetes, the Secret object holds the value, the Deployment passes it to the container as an environment variable or a mounted file, and the configuration file refers to it with `${NAME}`, `$env` or `$file`. The file then contains only a reference, so it can be stored and reviewed freely.

Backstage reads its configuration when it starts. Changing a Secret object does not change a running process, so rotating a secret means updating the Secret and restarting the pods. An old value stays valid at the issuer until it is revoked, so rotation also includes revoking the old credential.

Key facts:

- The default visibility is `backend`.
- `secret` is never sent to the browser; `frontend` always is.
- Typed readers check the type and the required readers throw when a value is missing.
- A reference in a file is safe to store; the value behind it is not.

<!-- astrona:playground:destroy -->
