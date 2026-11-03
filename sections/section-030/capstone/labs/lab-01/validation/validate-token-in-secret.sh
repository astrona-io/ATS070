#!/usr/bin/env bash
# Check: the Secret backstage-secrets holds GITHUB_TOKEN with the value that
# the Deployment used to carry in plain text.
set -uo pipefail

value="$(kubectl -n backstage get secret backstage-secrets -o jsonpath='{.data.GITHUB_TOKEN}' 2>/dev/null | base64 -d 2>/dev/null)"
if [ "$value" != "ghp_labtokenvalue0000" ]; then
  echo "FAIL: Secret backstage-secrets must have the key GITHUB_TOKEN with the value ghp_labtokenvalue0000"
  exit 1
fi
echo "PASS: backstage-secrets holds GITHUB_TOKEN"
