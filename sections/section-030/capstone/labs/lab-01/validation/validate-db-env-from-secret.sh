#!/usr/bin/env bash
# Check: the Backstage container reads the PostgreSQL credentials from the
# Secret postgres-secrets and sets POSTGRES_HOST and POSTGRES_PORT itself.
set -uo pipefail

deployment="$(kubectl -n backstage get deployment backstage -o json)"
fail=0

has_secret="$(echo "$deployment" | jq '[.spec.template.spec.containers[0].envFrom[]? | select(.secretRef.name == "postgres-secrets")] | length')"
if [ "$has_secret" -lt 1 ]; then
  echo "FAIL: the container has no envFrom reference to the Secret postgres-secrets"
  fail=1
fi

host="$(echo "$deployment" | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "POSTGRES_HOST") | .value')"
case "$host" in
  postgres|postgres.backstage|postgres.backstage.svc|postgres.backstage.svc.cluster.local) ;;
  *)
    echo "FAIL: POSTGRES_HOST is '$host'; it must name the postgres Service"
    fail=1
    ;;
esac

port="$(echo "$deployment" | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "POSTGRES_PORT") | .value')"
if [ "$port" != "5432" ]; then
  echo "FAIL: POSTGRES_PORT is '$port'; it must be 5432"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: credentials come from postgres-secrets and host and port are set"
fi
exit "$fail"
