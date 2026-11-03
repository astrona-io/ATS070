#!/usr/bin/env bash
# Check: two running Backstage pods are ready and use the probes, so the
# rollout of the changed template is finished.
set -uo pipefail

pods="$(kubectl -n backstage get pods -l app=backstage -o json)"
ready="$(echo "$pods" | jq '[.items[]
  | select(.metadata.deletionTimestamp == null)
  | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))
  | select(.spec.containers[0].livenessProbe != null)] | length')"

if [ "$ready" -lt 2 ]; then
  echo "FAIL: $ready ready Backstage pods with a liveness probe; wait for the rollout to finish (2 are needed)"
  exit 1
fi
echo "PASS: two ready Backstage pods run the new template"
