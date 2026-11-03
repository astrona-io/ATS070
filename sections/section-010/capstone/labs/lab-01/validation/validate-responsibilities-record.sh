#!/usr/bin/env bash
# Check: portal-responsibilities has the four keys and they match the cluster.
set -uo pipefail

fail=0
cm="$(kubectl -n backstage get configmap portal-responsibilities -o json 2>/dev/null)"
if [ -z "$cm" ]; then
  echo "FAIL: ConfigMap portal-responsibilities does not exist in backstage"
  exit 1
fi
get() { echo "$cm" | jq -r --arg k "$1" '.data[$k] // empty'; }
[ "$(get owner)" = "platform-team" ] || { echo "FAIL: owner must be platform-team"; fail=1; }
get database | grep -qi 'postgres' || { echo "FAIL: database must name PostgreSQL as the production database"; fail=1; }
[ -n "$(get identity)" ] || { echo "FAIL: identity must not be empty"; fail=1; }
image="$(kubectl -n backstage get deployment backstage -o jsonpath='{.spec.template.spec.containers[0].image}' 2>/dev/null)"
[ "$(get release)" = "${image##*:}" ] || { echo "FAIL: release must be the image tag ${image##*:}"; fail=1; }
[ "$fail" -eq 0 ] && echo "PASS: portal-responsibilities is complete"
exit "$fail"
