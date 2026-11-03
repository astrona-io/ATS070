#!/usr/bin/env bash
# Check: external access for the CI caller.
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

text="$(config_text)"
fail=0
echo "$text" | grep -Eq '^[[:space:]]*-[[:space:]]*type:[[:space:]]*static' || { echo "FAIL: no externalAccess entry with type static"; fail=1; }
echo "$text" | grep -Eq '^[[:space:]]*subject:[[:space:]]*starfleet-ci[[:space:]]*$' || { echo "FAIL: subject starfleet-ci is missing"; fail=1; }
echo "$text" | grep -Eq '^[[:space:]]*token:[[:space:]]*\$\{CI_TOKEN\}[[:space:]]*$' || { echo "FAIL: token must be the placeholder \${CI_TOKEN}"; fail=1; }
echo "$text" | grep -Eq '^[[:space:]]*-[[:space:]]*plugin:[[:space:]]*catalog[[:space:]]*$' || { echo "FAIL: accessRestrictions must name plugin catalog"; fail=1; }
[ "$fail" -eq 0 ] && echo "PASS: starfleet-ci has a restricted static token entry"
exit "$fail"
