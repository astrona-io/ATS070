#!/usr/bin/env bash
# Check: the production overlay ConfigMap sets organization.name and a
# one-item methods list, is mounted at /etc/backstage-production and is the
# last --config flag.
set -uo pipefail

fail=0
text="$(kubectl -n backstage get configmap backstage-app-config-production -o jsonpath='{.data.app-config\.production\.yaml}' 2>/dev/null)"
if [ -z "$text" ]; then
  echo "FAIL: ConfigMap backstage-app-config-production with key app-config.production.yaml not found or empty"
  exit 1
fi
if ! echo "$text" | grep -Eq '^organization:'; then
  echo "FAIL: the file has no top-level key organization"
  fail=1
fi
if ! echo "$text" | grep -Eq '^[[:space:]]+name:[[:space:]]*"?Starfleet Production"?[[:space:]]*$'; then
  echo "FAIL: organization.name is not 'Starfleet Production'"
  fail=1
fi
if ! echo "$text" | grep -Eq '^[[:space:]]+methods:[[:space:]]*\[[[:space:]]*"?GET"?[[:space:]]*\][[:space:]]*$'; then
  echo "FAIL: backend.cors.methods is not the one-item list [GET]"
  fail=1
fi

dep="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null)"
path="/etc/backstage-production/app-config.production.yaml"
last_flag="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].args | last')"
before_last="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].args | .[-2]')"
if [ "$last_flag" != "$path" ] || [ "$before_last" != "--config" ]; then
  echo "FAIL: $path must be the last --config flag"
  fail=1
fi
mount="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].volumeMounts[]? | select(.mountPath == "/etc/backstage-production") | .name')"
source_cm="$(echo "$dep" | jq -r --arg n "$mount" '.spec.template.spec.volumes[]? | select(.name == $n) | .configMap.name')"
if [ -z "$mount" ] || [ "$source_cm" != "backstage-app-config-production" ]; then
  echo "FAIL: backstage-app-config-production is not mounted at /etc/backstage-production"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: the production overlay is mounted and loaded last"
fi
exit "$fail"
