#!/usr/bin/env bash
# Check: the Deployment was restarted, keeps its image, is available, and the
# ready pod that runs now mounts the new title.
set -uo pipefail

fail=0
restarted="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.metadata.annotations.kubectl\.kubernetes\.io/restartedAt}' 2>/dev/null)"
if [ -z "$restarted" ]; then
  echo "FAIL: the Deployment was not restarted after the change (no restartedAt annotation)"
  fail=1
fi
image="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
if [ "$image" != "ghcr.io/backstage/backstage:1.55.2" ]; then
  echo "FAIL: image is '$image', expected ghcr.io/backstage/backstage:1.55.2"
  fail=1
fi
pod="$(kubectl -n backstage get pods -l app=backstage -o json | jq -r '[.items[] | select(.metadata.deletionTimestamp == null) | select(any(.status.conditions[]?; .type == "Ready" and .status == "True"))][0].metadata.name // empty')"
if [ -z "$pod" ]; then
  echo "FAIL: no ready backstage pod"
  exit 1
fi
if ! kubectl -n backstage exec "$pod" -- cat /etc/backstage/app-config.lab.yaml | grep -q 'Starfleet Developer Portal'; then
  echo "FAIL: the ready pod $pod does not mount the new title"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: restarted, same image, ready pod $pod mounts the new title"
exit "$fail"
