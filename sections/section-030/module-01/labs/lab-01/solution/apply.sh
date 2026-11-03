#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/backstage-app-config.yaml"
kubectl -n backstage patch deployment backstage --patch-file "$DIR/backstage-database-patch.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[solution] Applied."
