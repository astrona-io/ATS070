#!/usr/bin/env bash
# Check: a running Backstage pod (not a terminating one) was created from the
# changed template, so it has the PostgreSQL variables, and it is ready.
set -uo pipefail

pods="$(kubectl -n backstage get pods -l app=backstage -o json)"
ready="$(echo "$pods" | jq '[.items[]
  | select(.metadata.deletionTimestamp == null)
  | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))
  | select(any(.spec.containers[0].env[]?; .name == "POSTGRES_HOST"))] | length')"

if [ "$ready" -lt 1 ]; then
  echo "FAIL: no ready Backstage pod has the POSTGRES_HOST variable; roll out the change and wait for the pod"
  exit 1
fi
echo "PASS: a ready Backstage pod runs with the PostgreSQL variables"
