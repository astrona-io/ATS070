#!/usr/bin/env bash
# Check: the database password value is in no ConfigMap and in no plain
# environment value of the Backstage Deployment.
set -uo pipefail

password="starfleet-db-pass"
fail=0

if kubectl -n backstage get configmap backstage-app-config -o yaml | grep -q "$password"; then
  echo "FAIL: the ConfigMap contains the database password"
  fail=1
fi
if kubectl -n backstage get deployment backstage -o json | grep -q "$password"; then
  echo "FAIL: the Backstage Deployment contains the database password as plain text"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the database password is in neither the ConfigMap nor the Deployment"
fi
exit "$fail"
