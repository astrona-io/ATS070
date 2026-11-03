#!/usr/bin/env bash
# Starting state for the backend authentication lab. The default auth policy is switched off, the permission framework is off and the Secret portal-secrets holds CI_TOKEN.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
