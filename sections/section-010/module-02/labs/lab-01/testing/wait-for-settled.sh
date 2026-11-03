#!/usr/bin/env bash
# Runs under `astrona test` after the reference solution: waits until the old
# pod is gone and one ready pod is left.
set -euo pipefail

for i in $(seq 1 60); do
  pods="$(kubectl -n backstage get pods -l app=backstage -o json)"
  total="$(echo "$pods" | jq '.items | length')"
  ready="$(echo "$pods" | jq '[.items[] | select(.metadata.deletionTimestamp == null) | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))] | length')"
  if [ "$total" = "1" ] && [ "$ready" = "1" ]; then
    echo "[testing] settled."
    exit 0
  fi
  sleep 3
done
echo "[testing] the Deployment did not settle in time." >&2
exit 1
