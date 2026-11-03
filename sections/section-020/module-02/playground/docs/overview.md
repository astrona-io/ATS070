# Overview: Visibility, Typing And Secret Boundaries (Playground)

This is a **playground**, not a lab. It starts a fresh cluster with Backstage running and then waits. There is no task, no `astrona submit` and no pass or fail. Look at schemas, move a secret out of a file, restart, look again, `astrona destroy`, start over.

## What's in the box

- A single-node `kind` cluster running Kubernetes 1.35. `kubectl` is already pointed at it.
- A Deployment `backstage` in the namespace `backstage` with one replica. It loads `app-config.yaml` from the image and `/etc/backstage/app-config.lab.yaml` from the ConfigMap `backstage-app-config`.
- The ConfigMap sets the portal title, the organization name, the backend address, an in-memory SQLite database and, on purpose, a plain-text example GitHub token (`ghp_starfleet_example_0000`, not a real credential) under `integrations.github`.
- No Secret exists yet. The Deployment has no environment variables.
- A Service `backstage` on port 7007, also forwarded to `http://127.0.0.1:7007`.
- Backstage needs a minute or more to start.

## Helpers

Paste this once in each new terminal. `restart_backstage` restarts the pod so that Backstage reads its configuration and environment again and waits until the new pod is ready. `show_token_text` lists every ConfigMap in the namespace that still contains the example token text.

```sh
restart_backstage() {
  kubectl -n backstage rollout restart deployment/backstage
  kubectl -n backstage rollout status deployment/backstage --timeout=300s
}
show_token_text() {
  kubectl -n backstage get configmaps -o json | jq -r '.items[] | select(any(.data[]?; contains("ghp_starfleet_example"))) | .metadata.name'
}
```

## Practice tasks

- Run `show_token_text`, then create the Secret `backstage-secrets`, reference it with `${GITHUB_TOKEN}`, restart, and run `show_token_text` again.
- Find the `config.d.ts` files in `/app/node_modules/@backstage` and read the visibility annotations of one package.
- Rotate the token: change the Secret value, check the variable in the running pod, restart the pod and check it again.
- Set `APP_CONFIG_organization_name` from a Secret key with `valueFrom.secretKeyRef` instead of `--from=secret`, and explain the difference.
- Mount the Secret as a file and use `$file` for the token instead of an environment variable.
