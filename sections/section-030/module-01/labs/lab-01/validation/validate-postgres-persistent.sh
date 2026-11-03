#!/usr/bin/env bash
# Check: PostgreSQL still keeps its data on the PersistentVolumeClaim
# postgres-data and is available.
set -uo pipefail

fail=0
phase="$(kubectl -n backstage get pvc postgres-data -o jsonpath='{.status.phase}' 2>/dev/null)"
if [ "$phase" != "Bound" ]; then
  echo "FAIL: PersistentVolumeClaim postgres-data is '$phase', not Bound"
  fail=1
fi

claim="$(kubectl -n backstage get deployment postgres -o jsonpath='{.spec.template.spec.volumes[*].persistentVolumeClaim.claimName}' 2>/dev/null)"
if [ "$claim" != "postgres-data" ]; then
  echo "FAIL: the postgres Deployment does not mount postgres-data"
  fail=1
fi

available="$(kubectl -n backstage get deployment postgres -o jsonpath='{.status.availableReplicas}' 2>/dev/null)"
if [ "${available:-0}" -lt 1 ]; then
  echo "FAIL: the postgres Deployment has no available replica"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: postgres runs on the bound claim postgres-data"
fi
exit "$fail"
