#!/usr/bin/env bash
# Starting state for the base URL lab. The ConfigMap still describes a local development setup.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
