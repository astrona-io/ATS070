#!/usr/bin/env bash
# Check: the backend rejects a request without credentials (any status except 200). Runs a request inside the pod with Node.
set -uo pipefail

pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null)][0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no running backstage pod"
  exit 1
fi
status="$(kubectl -n backstage exec "$pod" -- node -e "fetch('http://localhost:7007/api/catalog/entities').then(r => console.log(r.status)).catch(() => console.log('error'))" 2>/dev/null | tail -n 1)"
case "$status" in
  ''|error) echo "FAIL: the backend did not answer; wait for the pod to become ready"; exit 1 ;;
  200) echo "FAIL: a request without credentials returned 200"; exit 1 ;;
esac
echo "PASS: a request without credentials returned ${status}, not 200"
