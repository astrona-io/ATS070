#!/usr/bin/env bash
# Check: the pod that runs now (not the Deployment text) has the production
# file and the variable. Terminating pods are ignored.
set -uo pipefail

pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null)] | .[0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no running backstage pod found"
  exit 1
fi

fail=0
if ! kubectl -n backstage exec "$pod" -- test -f /etc/backstage-production/app-config.production.yaml; then
  echo "FAIL: pod $pod does not have /etc/backstage-production/app-config.production.yaml; wait for the rollout"
  fail=1
fi
value="$(kubectl -n backstage exec "$pod" -- printenv APP_CONFIG_organization_name 2>/dev/null)"
if [ "$value" != "Starfleet Command" ]; then
  echo "FAIL: pod $pod has APP_CONFIG_organization_name='$value'; wait for the rollout"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the running pod has the production file and the variable"
fi
exit "$fail"
