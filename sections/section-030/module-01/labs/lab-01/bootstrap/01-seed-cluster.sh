#!/usr/bin/env bash
# Starting state. Environment only: it creates the workloads and leaves the
# production settings for the learner to make.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/postgres --timeout=300s
  kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
