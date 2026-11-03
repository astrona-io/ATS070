#!/usr/bin/env bash
# Check: the readiness endpoint answers 200 through the Service.
set -uo pipefail

code="$(kubectl -n backstage run readiness-check --rm -i --restart=Never --image=curlimages/curl:8.22.0 --image-pull-policy=IfNotPresent --command -- curl -s -o /dev/null -w '%{http_code}' --max-time 10 http://backstage.backstage.svc.cluster.local:7007/.backstage/health/v1/readiness 2>/dev/null | tail -c 3)"
if [ "$code" = "200" ]; then
  echo "PASS: readiness endpoint answers 200"
  exit 0
fi
echo "FAIL: readiness endpoint answered '$code'"
exit 1
