#!/usr/bin/env bash
# Starting state for the section capstone. Development addresses, default auth policy off, no permission framework and a literal CI token in the ConfigMap.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
