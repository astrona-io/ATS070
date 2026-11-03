#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits until two ready pods run and no old pod is terminating.
set -euo pipefail

for attempt in $(seq 1 60); do
  terminating="$(kubectl -n backstage get pods -l app=backstage -o json | jq '[.items[] | select(.metadata.deletionTimestamp != null)] | length')"
  ready="$(kubectl -n backstage get deployment backstage -o jsonpath='{.status.readyReplicas}')"
  if [ "$terminating" = "0" ] && [ "${ready:-0}" -ge 2 ]; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 5
done
echo "[testing] the cluster did not settle in time." >&2
exit 1
