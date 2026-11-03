#!/usr/bin/env bash
# Starting state: a portal that does not start. The ConfigMap key does not match
# the --config path, the title is generic, the catalog accepts Template and the
# Deployment has no owner. Environment only. The pod is expected to fail.
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

kubectl apply -f "$DIR/manifests/lab-start.yaml"
for i in $(seq 1 60); do
  if [ -n "$(kubectl -n backstage get pods -l app=backstage -o name)" ]; then
    echo "[lab] Ready (the portal pod exists and does not start; that is the task)."
    exit 0
  fi
  sleep 2
done
echo "[lab] the pod was not created in time." >&2
exit 1
