#!/usr/bin/env bash
# Starting state for the secret lab. Environment only: it creates Backstage
# with a plain-text example token in its ConfigMap. It does not create the
# Secret the learner must add.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
