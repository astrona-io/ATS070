#!/usr/bin/env bash
# Check: the Deployment sets APP_CONFIG_organization_name to Starfleet Command.
set -uo pipefail

value="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "APP_CONFIG_organization_name") | .value')"
if [ "$value" = "Starfleet Command" ]; then
  echo "PASS: APP_CONFIG_organization_name is set to Starfleet Command"
  exit 0
fi
echo "FAIL: APP_CONFIG_organization_name is '$value', expected 'Starfleet Command'"
exit 1
