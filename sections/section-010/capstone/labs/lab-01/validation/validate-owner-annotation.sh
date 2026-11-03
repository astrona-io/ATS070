#!/usr/bin/env bash
# Check: the Deployment carries the owner annotation.
set -uo pipefail

owner="$(kubectl -n backstage get deployment backstage -o jsonpath='{.metadata.annotations.portal\.starfleet\.example/owner}' 2>/dev/null)"
if [ "$owner" = "platform-team" ]; then
  echo "PASS: owner annotation is platform-team"
  exit 0
fi
echo "FAIL: annotation portal.starfleet.example/owner is '$owner', expected platform-team"
exit 1
