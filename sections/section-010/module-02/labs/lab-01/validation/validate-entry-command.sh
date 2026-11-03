#!/usr/bin/env bash
# Check: anatomy-record names the real start command of the backend.
set -uo pipefail

value="$(kubectl -n backstage get configmap anatomy-record -o jsonpath='{.data.entry-command}' 2>/dev/null)"
actual="$(kubectl -n backstage get deployment backstage -o json | jq -r '(.spec.template.spec.containers[0].command // []) | join(" ")')"
if [ -n "$value" ] && [ "$value" = "$actual" ]; then
  echo "PASS: entry-command is '$value'"
  exit 0
fi
echo "FAIL: entry-command is '$value', the Deployment runs '$actual'"
exit 1
