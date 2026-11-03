#!/usr/bin/env bash
# Check: the configuration text has the title and the catalog rule, without
# Template, and the ready pod really mounts that title.
set -uo pipefail

fail=0
text="$(kubectl -n backstage get configmap backstage-app-config -o json 2>/dev/null | jq -r '.data // {} | to_entries | map(.value) | join("\n")')"
if ! echo "$text" | grep -Eq '^[[:space:]]+title:[[:space:]]*"?Starfleet Developer Portal"?[[:space:]]*$'; then
  echo "FAIL: app.title is not Starfleet Developer Portal"
  fail=1
fi
allow="$(echo "$text" | grep -E 'allow:' | head -n 1)"
if [ -z "$allow" ]; then
  echo "FAIL: no catalog.rules allow list"
  fail=1
else
  for kind in Component System API Resource Location; do
    echo "$allow" | grep -q "$kind" || { echo "FAIL: allow list does not contain $kind"; fail=1; }
  done
  if echo "$allow" | grep -q "Template"; then
    echo "FAIL: allow list must not contain Template"
    fail=1
  fi
fi
pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null) | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))][0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no ready backstage pod"
  exit 1
fi
if ! kubectl -n backstage exec "$pod" -- sh -c 'cat /etc/backstage/*' | grep -q 'Starfleet Developer Portal'; then
  echo "FAIL: the ready pod does not mount the new title under /etc/backstage"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: title and catalog rule are set and mounted in the ready pod"
exit "$fail"
