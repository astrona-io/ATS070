#!/usr/bin/env bash
# Applies the reference solution. Run only by `astrona test`.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

kubectl apply -f "$DIR/overlay.yaml"
kubectl apply -f "$DIR/deployment.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[solution] Applied."
