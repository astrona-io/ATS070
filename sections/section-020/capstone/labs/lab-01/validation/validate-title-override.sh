#!/usr/bin/env bash
# Check: the Deployment sets APP_CONFIG_app_title to Starfleet Portal Live.
set -uo pipefail

value="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "APP_CONFIG_app_title") | .value')"
if [ "$value" = "Starfleet Portal Live" ]; then
  echo "PASS: APP_CONFIG_app_title is set to Starfleet Portal Live"
  exit 0
fi
echo "FAIL: APP_CONFIG_app_title is '$value', expected 'Starfleet Portal Live'"
exit 1
