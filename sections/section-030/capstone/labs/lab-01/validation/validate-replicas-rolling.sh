#!/usr/bin/env bash
# Check: two replicas and a rolling update that never removes a ready pod
# before its replacement is ready (maxUnavailable 0).
set -uo pipefail

deployment="$(kubectl -n backstage get deployment backstage -o json)"
fail=0

replicas="$(echo "$deployment" | jq -r '.spec.replicas')"
if [ "$replicas" != "2" ]; then
  echo "FAIL: spec.replicas is $replicas, not 2"
  fail=1
fi
type="$(echo "$deployment" | jq -r '.spec.strategy.type')"
unavailable="$(echo "$deployment" | jq -r '.spec.strategy.rollingUpdate.maxUnavailable')"
if [ "$type" != "RollingUpdate" ] || { [ "$unavailable" != "0" ] && [ "$unavailable" != "0%" ]; }; then
  echo "FAIL: the strategy must be RollingUpdate with maxUnavailable 0 (found $type, $unavailable)"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: two replicas with a rolling update that keeps every ready pod until the next one is ready"
fi
exit "$fail"
