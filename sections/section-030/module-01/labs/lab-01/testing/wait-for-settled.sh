#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits until only the new Backstage pod is running and ready.
set -euo pipefail

for attempt in $(seq 1 60); do
  not_ready="$(kubectl -n backstage get pods -l app=backstage -o json | jq '[.items[] | select(.metadata.deletionTimestamp != null)] | length')"
    ready="$(kubectl -n backstage get deployment backstage -o jsonpath='{.status.readyReplicas}')"
    if [ "$not_ready" = "0" ] && [ "${ready:-0}" -ge 1 ]; then
      echo "[testing] settled."
      exit 0
    fi
  sleep 5
done
echo "[testing] the cluster did not settle in time." >&2
exit 1
