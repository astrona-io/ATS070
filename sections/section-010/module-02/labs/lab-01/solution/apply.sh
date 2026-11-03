#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/extra-config.yaml"

# Second configuration layer: a new volume, a new mount and a last --config flag.
kubectl -n backstage patch deployment backstage --type=json -p '[
  {"op":"add","path":"/spec/template/spec/volumes/-","value":{"name":"app-config-extra","configMap":{"name":"backstage-app-config-extra"}}},
  {"op":"add","path":"/spec/template/spec/containers/0/volumeMounts/-","value":{"name":"app-config-extra","mountPath":"/etc/backstage-extra","readOnly":true}},
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"--config"},
  {"op":"add","path":"/spec/template/spec/containers/0/args/-","value":"/etc/backstage-extra/app-config.extra.yaml"}
]'
kubectl -n backstage rollout status deployment/backstage --timeout=300s

# Anatomy record, taken from the running pod.
plugins="$(kubectl -n backstage exec deployment/backstage -- sh -c 'ls /app/node_modules/@backstage | grep "^plugin-.*-backend$" | head -n 3')"
release="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}' | sed 's/.*://')"
kubectl -n backstage create configmap anatomy-record \
  --from-literal=entry-command='node packages/backend' \
  --from-literal=backend-plugins="$plugins" \
  --from-literal=release="$release" \
  --dry-run=client -o yaml | kubectl apply -f -
echo "[solution] Applied."
