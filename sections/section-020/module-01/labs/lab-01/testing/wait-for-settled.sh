#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits until the old
# pod is gone and exactly one pod is running.
set -euo pipefail

for i in $(seq 1 60); do
  total="$(kubectl -n backstage get pods -l app=backstage -o json | jq '.items | length')"
  if [ "$total" = "1" ]; then
    kubectl -n backstage rollout status deployment/backstage --timeout=300s
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] the pods did not settle in time." >&2
exit 1
