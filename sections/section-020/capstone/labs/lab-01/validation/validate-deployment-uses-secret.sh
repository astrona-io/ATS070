#!/usr/bin/env bash
# Check: the container takes SCM_TOKEN from the Secret portal-secrets,
# by secretKeyRef or envFrom, and never as a literal value.
set -uo pipefail

dep="$(kubectl -n backstage get deployment backstage -o json 2>/dev/null)"
if [ -z "$dep" ]; then
  echo "FAIL: Deployment backstage not found"
  exit 1
fi

literal="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "SCM_TOKEN") | .value // empty')"
if [ -n "$literal" ]; then
  echo "FAIL: SCM_TOKEN is set as a literal value in the Deployment"
  exit 1
fi

by_key="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].env[]? | select(.name == "SCM_TOKEN") | .valueFrom.secretKeyRef | select(.name == "portal-secrets" and .key == "SCM_TOKEN") | .name')"
by_from="$(echo "$dep" | jq -r '.spec.template.spec.containers[0].envFrom[]? | .secretRef.name // empty | select(. == "portal-secrets")')"
if [ -n "$by_key" ] || [ -n "$by_from" ]; then
  echo "PASS: SCM_TOKEN comes from the Secret portal-secrets"
  exit 0
fi
echo "FAIL: the container does not take SCM_TOKEN from the Secret portal-secrets"
exit 1
