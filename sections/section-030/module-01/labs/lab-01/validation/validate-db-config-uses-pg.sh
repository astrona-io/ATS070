#!/usr/bin/env bash
# Check: the ConfigMap backstage-app-config selects PostgreSQL and reads the
# connection values from ${POSTGRES_*} substitutions.
set -uo pipefail

config="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}' 2>/dev/null)"
if [ -z "$config" ]; then
  echo "FAIL: ConfigMap backstage-app-config has no key app-config.lab.yaml"
  exit 1
fi

fail=0
if ! echo "$config" | grep -Eq '^[[:space:]]*client:[[:space:]]*pg[[:space:]]*$'; then
  echo "FAIL: backend.database.client is not pg"
  fail=1
fi
if echo "$config" | grep -q 'better-sqlite3'; then
  echo "FAIL: the configuration still names better-sqlite3"
  fail=1
fi
for variable in POSTGRES_HOST POSTGRES_PORT POSTGRES_USER POSTGRES_PASSWORD; do
  if ! echo "$config" | grep -q "\${$variable}"; then
    echo "FAIL: the connection does not read \${$variable}"
    fail=1
  fi
done

if [ "$fail" -eq 0 ]; then
  echo "PASS: the configuration uses PostgreSQL with \${POSTGRES_*} values"
fi
exit "$fail"
