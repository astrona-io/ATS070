#!/usr/bin/env bash
# Check: the pod that runs now has SCM_TOKEN with the rotated value.
# Terminating pods are ignored.
set -uo pipefail

pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null)] | .[0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no running backstage pod found"
  exit 1
fi
value="$(kubectl -n backstage exec "$pod" -- printenv SCM_TOKEN 2>/dev/null)"
if [ "$value" = "ghp_starfleet_example_0002" ]; then
  echo "PASS: the running pod has the rotated token"
  exit 0
fi
echo "FAIL: pod $pod does not have the rotated SCM_TOKEN; wait for the rollout"
exit 1
