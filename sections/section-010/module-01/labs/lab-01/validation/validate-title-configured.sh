#!/usr/bin/env bash
# Check: the ConfigMap file sets app.title to the required text.
set -uo pipefail

file="$(kubectl -n backstage get configmap backstage-app-config -o jsonpath='{.data.app-config\.lab\.yaml}' 2>/dev/null)"
if [ -z "$file" ]; then
  echo "FAIL: ConfigMap backstage-app-config has no key app-config.lab.yaml"
  exit 1
fi
if echo "$file" | grep -Eq '^[[:space:]]+title:[[:space:]]*"?Starfleet Developer Portal"?[[:space:]]*$'; then
  echo "PASS: app.title is Starfleet Developer Portal"
  exit 0
fi
echo "FAIL: app.title is not set to Starfleet Developer Portal"
exit 1
