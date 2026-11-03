#!/usr/bin/env bash
# Check: the ready pod that runs now has the extra file, the image is unchanged
# and the readiness endpoint answers 200.
set -uo pipefail

fail=0
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
if ! kubectl -n backstage exec "$pod" -- cat /etc/backstage-extra/app-config.extra.yaml | grep -q 'Starfleet Operations Portal'; then
  echo "FAIL: pod $pod has no /etc/backstage-extra/app-config.extra.yaml with the new title"
  fail=1
fi
code="$(kubectl -n backstage run readiness-check --rm -i --restart=Never --image=curlimages/curl:8.22.0 --image-pull-policy=IfNotPresent --command -- curl -s -o /dev/null -w '%{http_code}' --max-time 10 http://backstage.backstage.svc.cluster.local:7007/.backstage/health/v1/readiness 2>/dev/null | tail -c 3)"
if [ "$code" != "200" ]; then
  echo "FAIL: readiness endpoint answered '$code'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: pod $pod reads the extra file and the readiness endpoint answers 200"
exit "$fail"
