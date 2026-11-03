#!/usr/bin/env bash
# Check: the Deployment no longer carries the token value and reads the
# Secret backstage-secrets through envFrom.
set -uo pipefail

deployment="$(kubectl -n backstage get deployment backstage -o json)"
fail=0

if echo "$deployment" | grep -q 'ghp_labtokenvalue0000'; then
  echo "FAIL: the Deployment still contains the token value as plain text"
  fail=1
fi
has_secret="$(echo "$deployment" | jq '[.spec.template.spec.containers[0].envFrom[]? | select(.secretRef.name == "backstage-secrets")] | length')"
if [ "$has_secret" -lt 1 ]; then
  echo "FAIL: the container has no envFrom reference to the Secret backstage-secrets"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the token comes from backstage-secrets"
fi
exit "$fail"
