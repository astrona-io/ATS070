#!/usr/bin/env bash
# Check: public address values.
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
for entry in "app - baseUrl" "backend - baseUrl" "backend cors origin"; do
  set -- $entry
  value="$(config_value "$1" "$2" "$3")"
  if [ "$value" != "https://portal.starfleet.example" ]; then
    echo "FAIL: $1 $3 (under ${2}) is '${value}', expected https://portal.starfleet.example"
    fail=1
  fi
done
[ "$fail" -eq 0 ] && echo "PASS: app.baseUrl, backend.baseUrl and backend.cors.origin are https://portal.starfleet.example"
exit "$fail"
