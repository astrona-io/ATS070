#!/usr/bin/env bash
# Check: Backstage is available, keeps its original image and the two
# original --config flags. Passes before any change.
set -uo pipefail

dep="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null)"
if [ -z "$dep" ]; then
  echo "FAIL: Deployment backstage not found"
  exit 1
fi

fail=0
image="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].image')"
if [ "$image" != "ghcr.io/backstage/backstage:1.55.2" ]; then
  echo "FAIL: image is $image, expected ghcr.io/backstage/backstage:1.55.2"
  fail=1
fi
for p in "app-config.yaml" "/etc/backstage/app-config.lab.yaml"; do
  if [ "$(echo "$dep" | jq --arg p "$p" '.spec.template.spec.containers[0].args | index($p)')" = "null" ]; then
    echo "FAIL: the flag for $p was removed"
    fail=1
  fi
done
available="$(echo "$dep" | jq '.status.availableReplicas // 0')"
if [ "$available" -lt 1 ]; then
  echo "FAIL: no available replica; wait for the rollout or read the pod log"
  fail=1
fi

if [ "$fail" -eq 0 ]; then
  echo "PASS: Backstage is available with its image and original flags"
fi
exit "$fail"
