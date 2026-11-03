#!/usr/bin/env bash
# Check: the Deployment is available with a ready pod, and the readiness
# endpoint answers 200 through the Service.
set -uo pipefail

fail=0
ready="$(kubectl -n backstage get deployment backstage -o jsonpath='{.status.readyReplicas}' 2>/dev/null)"
if [ "${ready:-0}" -lt 1 ]; then
  echo "FAIL: the Deployment has no ready replica; read the pod log"
  exit 1
fi
code="$(kubectl -n backstage run readiness-check --rm -i --restart=Never --image=curlimages/curl:8.22.0 --image-pull-policy=IfNotPresent --command -- curl -s -o /dev/null -w '%{http_code}' --max-time 10 http://backstage.backstage.svc.cluster.local:7007/.backstage/health/v1/readiness 2>/dev/null | tail -c 3)"
if [ "$code" != "200" ]; then
  echo "FAIL: readiness endpoint answered '$code'"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the portal is ready and answers 200"
exit "$fail"
