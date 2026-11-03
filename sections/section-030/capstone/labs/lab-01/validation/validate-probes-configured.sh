#!/usr/bin/env bash
# Check: the Backstage container has a readiness probe and a liveness probe
# on the documented health endpoints, on the container port 7007.
set -uo pipefail

container="$(kubectl -n backstage get deployment backstage -o json | jq '.spec.template.spec.containers[0]')"
fail=0

check_probe() {
  local probe_field="$1"
  local expected_path="$2"
  local path port
  path="$(echo "$container" | jq -r ".${probe_field}.httpGet.path // empty")"
  port="$(echo "$container" | jq -r ".${probe_field}.httpGet.port // empty")"
  if [ "$path" != "$expected_path" ]; then
    echo "FAIL: ${probe_field} must be an httpGet probe on ${expected_path} (found '${path}')"
    fail=1
  fi
  if [ "$port" != "http" ] && [ "$port" != "7007" ]; then
    echo "FAIL: ${probe_field} must use the port http or 7007 (found '${port}')"
    fail=1
  fi
}

check_probe readinessProbe /.backstage/health/v1/readiness
check_probe livenessProbe /.backstage/health/v1/liveness

if [ "$fail" -eq 0 ]; then
  echo "PASS: readiness and liveness probes use the Backstage health endpoints"
fi
exit "$fail"
