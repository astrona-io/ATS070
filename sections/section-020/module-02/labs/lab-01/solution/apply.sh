#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/secret.yaml"

# Replace the plain-text token with a reference in the ConfigMap.
current="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}')"
updated="$(printf '%s\n' "$current" | sed 's/token: ghp_starfleet_example_0000/token: ${GITHUB_TOKEN}/')"
kubectl -n backstage create configmap backstage-app-config \
  --from-literal=app-config.lab.yaml="$updated" \
  --dry-run=client -o yaml | kubectl apply -f -

kubectl -n backstage set env deployment/backstage --from=secret/backstage-secrets
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[solution] Applied."
