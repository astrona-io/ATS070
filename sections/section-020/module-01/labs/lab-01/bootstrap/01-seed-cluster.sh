#!/usr/bin/env bash
# Starting state for the layered configuration lab. Environment only: it
# creates Backstage with one mounted file. It does not create the production
# file, the volume or the environment variable the learner must add.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
kubectl -n backstage rollout status deployment/backstage --timeout=300s
echo "[lab] Ready."
