#!/usr/bin/env bash
# Check: anatomy-record lists at least three backend plugin packages and each
# one exists in the running pod.
set -uo pipefail

list="$(kubectl -n backstage get configmap anatomy-record -o jsonpath='{.data.backend-plugins}' 2>/dev/null)"
pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null) | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))][0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no ready backstage pod"
  exit 1
fi
count=0
fail=0
while IFS= read -r name; do
  name="$(echo "$name" | tr -d '[:space:]')"
  [ -z "$name" ] && continue
  if ! echo "$name" | grep -Eq '^plugin-[a-z0-9-]+-backend$'; then
    echo "FAIL: '$name' is not a name of the form plugin-<id>-backend"
    fail=1
    continue
  fi
  if kubectl -n backstage exec "$pod" -- test -d "/app/node_modules/@backstage/$name"; then
    count=$((count + 1))
  else
    echo "FAIL: /app/node_modules/@backstage/$name does not exist in the pod"
    fail=1
  fi
done <<< "$list"
if [ "$count" -lt 3 ]; then
  echo "FAIL: found $count valid backend plugin packages, need at least 3"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: $count backend plugin packages exist in the pod"
exit "$fail"
