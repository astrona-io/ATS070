#!/usr/bin/env bash
# Check: the Secret portal-secrets has SCM_TOKEN with the rotated value.
set -uo pipefail

value="$(kubectl -n backstage get secret portal-secrets -o jsonpath='{.data.SCM_TOKEN}' 2>/dev/null | base64 -d 2>/dev/null)"
if [ -z "$value" ]; then
  echo "FAIL: Secret portal-secrets with key SCM_TOKEN not found"
  exit 1
fi
if [ "$value" = "ghp_starfleet_example_0002" ]; then
  echo "PASS: the Secret holds the rotated token"
  exit 0
fi
if [ "$value" = "ghp_starfleet_example_0000" ]; then
  echo "FAIL: the Secret still holds the leaked token; use the new value from the task"
  exit 1
fi
echo "FAIL: the Secret value is not the rotated token from the task"
exit 1
