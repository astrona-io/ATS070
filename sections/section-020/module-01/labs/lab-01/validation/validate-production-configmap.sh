#!/usr/bin/env bash
# Check: the ConfigMap backstage-app-config-production has the key
# app-config.production.yaml with the title and a methods list of two items.
set -uo pipefail

text="$(kubectl -n backstage get configmap backstage-app-config-production -o jsonpath='{.data.app-config\.production\.yaml}' 2>/dev/null)"
if [ -z "$text" ]; then
  echo "FAIL: ConfigMap backstage-app-config-production with key app-config.production.yaml not found or empty"
  exit 1
fi

fail=0
if ! echo "$text" | grep -Eq '^[[:space:]]+title:[[:space:]]*"?Starfleet Portal Production"?[[:space:]]*$'; then
  echo "FAIL: app.title is not 'Starfleet Portal Production'"
  fail=1
fi
if ! echo "$text" | grep -Eq '^app:'; then
  echo "FAIL: the title is not under the top-level key app"
  fail=1
fi
if ! echo "$text" | grep -Eq '^[[:space:]]+methods:[[:space:]]*\[[[:space:]]*"?[A-Za-z]+"?[[:space:]]*,[[:space:]]*"?[A-Za-z]+"?[[:space:]]*\][[:space:]]*$'; then
  if ! echo "$text" | grep -Eq '^[[:space:]]+methods:[[:space:]]*$' || [ "$(echo "$text" | grep -Ec '^[[:space:]]+-[[:space:]]*\S+')" -ne 2 ]; then
    echo "FAIL: backend.cors.methods is not a list with exactly two items"
    fail=1
  fi
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the production file sets the title and a two-item methods list"
fi
exit "$fail"
