#!/usr/bin/env bash
# Check: the token is delivered from the Secret.
set -uo pipefail

config_text() {
  kubectl -n backstage get configmap backstage-app-config -o json | jq -r '.data["app-config.lab.yaml"]'
}

# config_value TOP MID LEAF reads one value from the configuration text.
# MID is "-" for a key directly under TOP (two spaces of indentation).
config_value() {
  config_text | awk -v top="$1" -v mid="$2" -v leaf="$3" '
    /^[^ #]/ { cur = $1; sub(/:$/, "", cur); m = ""; next }
    /^  [^ #]/ { k = $1; sub(/:$/, "", k); m = k; if (cur == top && mid == "-" && k == leaf) { v = $0; sub(/^[^:]*:[ ]*/, "", v); print v }; next }
    /^    [^ #]/ { k = $1; sub(/:$/, "", k); if (cur == top && m == mid && k == leaf) { v = $0; sub(/^[^:]*:[ ]*/, "", v); print v } }
  ' | sed -e "s/^['\"]//" -e "s/['\"]$//"
}

# pods_restarted_after_config_change succeeds when every running backstage pod
# was created after the last change of the ConfigMap.
pods_restarted_after_config_change() {
  local changed
  changed="$(kubectl -n backstage get configmap backstage-app-config -o json | jq -r '[.metadata.managedFields[]?.time] | max')"
  kubectl -n backstage get pods -l app=backstage -o json | jq -e --arg changed "$changed" '
    [.items[] | select(.metadata.deletionTimestamp == null)] as $pods
    | ($pods | length) >= 1 and all($pods[]; .metadata.creationTimestamp >= $changed)' >/dev/null
}

# deployment_is_available succeeds when the Deployment reports an available replica.
deployment_is_available() {
  [ "$(kubectl -n backstage get deployment backstage -o jsonpath='{.status.availableReplicas}' 2>/dev/null)" -ge 1 ] 2>/dev/null
}

fail=0
ref="$(kubectl -n backstage get deployment backstage -o json | jq -r '
  .spec.template.spec.containers[0].env[]? | select(.name == "CI_TOKEN") | .valueFrom.secretKeyRef | (.name + "/" + .key)')"
if [ "$ref" != "portal-secrets/CI_TOKEN" ]; then
  echo "FAIL: env CI_TOKEN must use secretKeyRef portal-secrets/CI_TOKEN; found '${ref}'"
  fail=1
fi
value="$(kubectl -n backstage get secret portal-secrets -o jsonpath='{.data.CI_TOKEN}' | base64 -d)"
if [ -n "$value" ] && config_text | grep -qF "$value"; then
  echo "FAIL: the token value is written in the ConfigMap"
  fail=1
fi
[ "$fail" -eq 0 ] && echo "PASS: the token comes from the Secret and is not in the ConfigMap"
exit "$fail"
