#!/usr/bin/env bash
# Check: the Deployment keeps its image and at least one replica.
set -uo pipefail

fail=0
image="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
replicas="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.replicas}' 2>/dev/null)"
if [ "$image" != "ghcr.io/backstage/backstage:1.55.2" ]; then
  echo "FAIL: image is '$image', expected ghcr.io/backstage/backstage:1.55.2"
  fail=1
fi
if [ "${replicas:-0}" -lt 1 ]; then
  echo "FAIL: the Deployment is scaled to $replicas replicas"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: image and replicas are unchanged"
exit "$fail"
